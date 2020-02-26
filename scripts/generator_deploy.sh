#!/usr/bin/env bash

# cd to project root
cd "$(dirname "${0}")" || exit
cd ../

# Create Namespace
cd kubernetes
kubectl create namespace generator

# Deploy crawler
kubectl apply -n generator -f generator/generator-deployment.yaml

# Finish
echo "DONE"
exit 0
