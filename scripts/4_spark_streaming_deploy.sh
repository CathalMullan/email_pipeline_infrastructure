#!/usr/bin/env bash

# cd to project root
cd "$(dirname "${0}")" || exit
cd ../

# Setup LoadBalancer information
kubectl config use-context kafka
kubectl config set-context --current --namespace kafka

export KAFKA_IP_0=$(kubectl get service kafka-cluster-kafka-0 -o=jsonpath='{.status.loadBalancer.ingress[0].ip}')
export KAFKA_IP_1=$(kubectl get service kafka-cluster-kafka-1 -o=jsonpath='{.status.loadBalancer.ingress[0].ip}')
export KAFKA_HOST="$KAFKA_IP_0:9094, $KAFKA_IP_1:9094"

# Create namespace.
kubectl config use-context streaming
kubectl create namespace streaming
kubectl create namespace spark-operator
kubectl config set-context --current --namespace streaming

# Create Kafka host secret (required by Spark).
export BASE64_KAFKA_HOST=$(echo -n "${KAFKA_HOST}" | base64)
envsubst < kubernetes/streaming/kafka_secret.yaml | kubectl apply -f -

# Deploy Spark streaming cluster setup
kubectl apply -f kubernetes/streaming/streaming_service_account.yaml
kubectl apply -f kubernetes/streaming/streaming_cluster_role_binding.yaml
kubectl create secret generic service-account --from-file=/Users/cmullan/.config/gcloud/gcp_service_account.json

# Install Spark-on-K8s operator.
helm repo add incubator http://storage.googleapis.com/kubernetes-charts-incubator
helm repo update
helm install streaming incubator/sparkoperator \
    --namespace spark-operator \
    --set sparkJobNamespace=streaming \
    --set enableMetrics=false \
    --wait

# Start/schedule job.
kubectl apply -f kubernetes/streaming/streaming_job.yaml
kubectl apply -f kubernetes/streaming/cron_pre_topic_model.yaml

echo "Finished deploying Streaming, now consuming Kafka events and storing in GCS."
