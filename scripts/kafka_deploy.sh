#!/usr/bin/env bash

# cd to project root
cd "$(dirname "${0}")" || exit
cd ../

# Create Namespace
kubectl create namespace kafka

# Apply Strimzi operator
kubectl apply -f kubernetes/helm/tiller.yaml
helm init --service-account=tiller
helm repo add strimzi http://strimzi.io/charts/
helm install strimzi/strimzi-kafka-operator

# Provision the Apache Kafka cluster
kubectl apply -f kubernetes/kafka/kafka-cluster.yaml
kubectl get statefulsets.apps,pod,deployments,svc

# Await creation
kubectl -n kafka wait kafka/kafka-cluster --for=condition=Ready --timeout=300s
kubectl -n kafka get statefulsets.apps,pod,deployments,svc

# Create topic
kubectl -n kafka apply -f kubernetes/kafka/kafka-topic.yaml

# Finish
echo "DONE"
exit 0
