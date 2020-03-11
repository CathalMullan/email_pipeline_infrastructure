#!/usr/bin/env bash

# cd to project root
cd "$(dirname "${0}")" || exit
cd ../

# Create Namespace
kubectl config use-context crawler_generator
kubectl create namespace crawler
kubectl label namespace crawler istio-injection=enabled
kubectl config set-context --current --namespace crawler

# Deploy crawler
envsubst < kubernetes/crawler/crawler-deployment.yaml | kubectl apply -f -

# Finish
echo "Finished deploying Crawler, now publishing events to Kafka queue."
