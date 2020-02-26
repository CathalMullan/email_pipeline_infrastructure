#!/usr/bin/env bash

# cd to project root
cd "$(dirname "${0}")" || exit
cd ../

# Create Namespace
cd kubernetes
kubectl create namespace crawler

# Deploy crawler
kubectl apply -n crawler -f crawler/crawler-deployment.yaml

# Finish
echo "DONE"
exit 0
