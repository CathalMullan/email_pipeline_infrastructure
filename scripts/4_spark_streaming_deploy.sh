#!/usr/bin/env bash

# cd to project root
cd "$(dirname "${0}")" || exit
cd ../

# Setup LoadBalancer information
kubectl config use-context kafka
kubectl config set-context --current --namespace kafka

export KAFKA_IP_0=$(kubectl get service kafka-cluster-kafka-0 -o=jsonpath='{.status.loadBalancer.ingress[0].ip}')
export KAFKA_IP_1=$(kubectl get service kafka-cluster-kafka-1 -o=jsonpath='{.status.loadBalancer.ingress[0].ip}')
export KAFKA_IP_2=$(kubectl get service kafka-cluster-kafka-2 -o=jsonpath='{.status.loadBalancer.ingress[0].ip}')
export KAFKA_HOST="$KAFKA_IP_0:9094, $KAFKA_IP_1:9094, $KAFKA_IP_2:9094"

# Create namespace and inject Istio.
kubectl config use-context streaming
kubectl create namespace streaming
kubectl label namespace streaming istio-injection=enabled
kubectl config set-context --current --namespace streaming

# Create Kafka host secret (required by Spark).
export BASE64_KAFKA_HOST=$(echo -n "${KAFKA_HOST}" | base64)
envsubst < kubernetes/streaming/kafka-secret.yaml | kubectl apply -f -

# Deploy Spark streaming cluster setup
kubectl apply -f kubernetes/streaming/streaming_service_account.yaml
kubectl apply -f kubernetes/streaming/streaming_cluster_role_binding.yaml

# Proxy and start job
kubectl proxy &
PROXY_PID=$!

sleep 10
timeout 120 /opt/spark/bin/spark-submit \
    --master k8s://http://127.0.0.1:8001 \
    --deploy-mode cluster \
    --name email_stream_processor \
    --packages org.apache.spark:spark-sql-kafka-0-10_2.12:3.0.0-preview2 \
    --conf spark.executor.instances=2 \
    --conf spark.dynamicAllocation.maxExecutors=8 \
    --conf spark.kubernetes.authenticate.driver.serviceAccountName=streaming \
    --conf spark.kubernetes.container.image=gcr.io/distributed-email-pipeline/email_stream_processor:latest \
    --conf spark.kubernetes.namespace=streaming \
    --conf spark.kubernetes.driver.secretKeyRef.KAFKA_HOSTS=kafka-secret:hosts \
    --conf spark.kubernetes.executor.secretKeyRef.KAFKA_HOSTS=kafka-secret:hosts \
    --conf spark.streaming.backpressure.enabled=true \
    /app/src/email_stream_processor/jobs/stream_pipeline.py

kill ${PROXY_PID}
