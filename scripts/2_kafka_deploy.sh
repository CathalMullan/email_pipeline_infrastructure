#!/usr/bin/env bash

# cd to project root.
cd "$(dirname "${0}")" || exit
cd ../

# Create namespace.
kubectl config use-context kafka
kubectl create namespace kafka
kubectl label namespace kafka istio-injection=enabled
kubectl config set-context --current --namespace kafka

# Install Strimzi operator.
curl -L https://github.com/strimzi/strimzi-kafka-operator/releases/download/0.15.0/strimzi-cluster-operator-0.15.0.yaml \
  | sed 's/namespace: .*/namespace: kafka/' \
  | kubectl apply -f - -n kafka

# Provision the Apache Kafka cluster.
kubectl apply -f kubernetes/kafka/kafka-cluster.yaml
kubectl wait kafka/kafka-cluster --for=condition=Ready --timeout=300s
kubectl get statefulsets.apps,pod,deployments,svc

# Create the Kafka topic 'email'.
kubectl apply -f kubernetes/kafka/kafka-topic.yaml

# Setup Credentials
kubectl create secret docker-registry gcr-cred \
    --docker-server=https://gcr.io \
    --docker-username=_json_key \
    --docker-password="$(cat ~/.config/gcloud/gcp_service_account.json)" \
    --docker-email="terraform@${PROJECT_ID}.iam.gserviceaccount.com"

# Setup LoadBalancer information
export KAFKA_IP_0=$(kubectl get service kafka-cluster-kafka-0 -o=jsonpath='{.status.loadBalancer.ingress[0].ip}')
export KAFKA_IP_1=$(kubectl get service kafka-cluster-kafka-1 -o=jsonpath='{.status.loadBalancer.ingress[0].ip}')
export KAFKA_IP_2=$(kubectl get service kafka-cluster-kafka-2 -o=jsonpath='{.status.loadBalancer.ingress[0].ip}')

export KAFKA_HOST="$KAFKA_IP_0:9094, $KAFKA_IP_1:9094, $KAFKA_IP_2:9094"
echo "Kafka Host(s): $KAFKA_HOST"

# Finish
echo "Finished deploying Kafka stack."
