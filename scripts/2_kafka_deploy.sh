#!/usr/bin/env bash

# cd to project root.
cd "$(dirname "${0}")" || exit
cd ../

export PROJECT_ID=$(gcloud info --format='value(config.project)')

# Create namespace.
kubectl config use-context kafka
kubectl create namespace kafka
kubectl config set-context --current --namespace kafka

# Install Strimzi operator.
helm repo add strimzi https://strimzi.io/charts/
helm repo update
helm install strimzi/strimzi-kafka-operator \
    --generate-name \
    --namespace kafka \
    --version 0.15.0 \
    --wait

# Provision the Apache Kafka cluster.
kubectl apply -f kubernetes/kafka/kafka-cluster.yaml
kubectl wait kafka/kafka-cluster --for=condition=Ready --timeout=900s

# Create the Kafka topic 'email'.
kubectl apply -f kubernetes/kafka/kafka-topic.yaml

# Setup Credentials
kubectl create secret docker-registry gcr-cred \
    --docker-server=https://gcr.io \
    --docker-username=_json_key \
    --docker-password="$(cat ~/.config/gcloud/gcp_service_account.json)" \
    --docker-email="terraform@${PROJECT_ID}.iam.gserviceaccount.com"

# Finish
echo "Finished deploying Kafka stack, ready to receive events."
