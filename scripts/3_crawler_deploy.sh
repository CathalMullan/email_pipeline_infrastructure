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
kubectl config use-context crawler_generator
kubectl create namespace crawler
kubectl config set-context --current --namespace crawler

# Deploy crawler.
envsubst < kubernetes/crawler/crawler_deployment.yaml | kubectl apply -f -

# Finish.
echo "Finished deploying Crawler, now publishing events to Kafka queue."
