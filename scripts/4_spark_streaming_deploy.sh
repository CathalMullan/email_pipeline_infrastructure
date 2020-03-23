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

# Create namespace.
kubectl config use-context streaming
kubectl create namespace streaming
kubectl config set-context --current --namespace streaming

# Create Kafka host secret (required by Spark).
export BASE64_KAFKA_HOST=$(echo -n "${KAFKA_HOST}" | base64)
envsubst < kubernetes/streaming/kafka-secret.yaml | kubectl apply -f -

# Deploy Spark streaming cluster setup
kubectl apply -f kubernetes/streaming/streaming_service_account.yaml
kubectl apply -f kubernetes/streaming/streaming_cluster_role_binding.yaml
kubectl create secret generic service-account --from-file=/Users/cmullan/.config/gcloud/gcp_service_account.json

# Use Spark-on-K8s-operator
helm repo add incubator http://storage.googleapis.com/kubernetes-charts-incubator

kubectl create namespace spark-operator
helm install incubator/sparkoperator \
    --generate-name \
    --namespace spark-operator \
    --set sparkJobNamespace=streaming \
    --wait

kubectl apply -f kubernetes/streaming/streaming_job.yaml
kubectl get sparkapplications
