#!/usr/bin/env bash

# Don't run as a script - follow like a runbook!
exit 0

cd terraform || exit

terraform init
terraform apply -auto-approve

kubectl config view
kubectl get pods --all-namespaces

cd ..
cd helm || exit

helm repo add stable https://kubernetes-charts.storage.googleapis.com/
helm repo update

kubectl create namespace spark
helm install --namespace spark -f spark-values.yaml spark stable/spark

# Wait for pods to be built
kubectl get pods --namespace spark
SPARK_MASTER=$(kubectl get pod -o=name --namespace spark | grep master)

# Master
kubectl --namespace spark port-forward "${SPARK_MASTER}" 2344:7077

# UI
kubectl --namespace spark port-forward "${SPARK_MASTER}" 2345:8080
