#!/usr/bin/env bash

# cd to project root
cd "$(dirname "${0}")" || exit
cd ../

# Create Namespace
kubectl config use-context crawler_generator
kubectl create namespace crawler
kubectl label namespace crawler istio-injection=enabled
kubectl config set-context --current --namespace crawler

# TODO.
# Create a mini Kafka producer using another image, run it in Kafka cluster - verify.
# Move to CG, hope it works.

# Create Istio service for Kafka connectivity
#envsubst < kubernetes/crawler/crawler-istio-kafka-service-entry.yaml | kubectl apply -f -

# Deploy crawler
#kubectl apply -f kubernetes/crawler/crawler-deployment.yaml

# Finish
echo "Finished deploying Crawler publishing events to Kafka over Istio mesh."
