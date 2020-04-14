#!/usr/bin/env bash

# cd to project root
cd "$(dirname "${0}")" || exit
cd ../

# Create namespace.
kubectl config use-context api
kubectl create namespace api
kubectl config set-context --current --namespace api

# Secret to allow GS connectivity.
kubectl create secret generic service-account --from-file=/Users/cmullan/.config/gcloud/gcp_service_account.json

# Setup API.
kubectl apply -f kubernetes/api
