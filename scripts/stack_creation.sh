#!/usr/bin/env bash

# cd to project root
cd "$(dirname "${0}")" || exit
cd ../

# Run Terraform
cd terraform
terraform apply -auto-approve

# Attach Kubectl
gcloud container clusters get-credentials $(terraform output distributed-email-pipeline_cluster) --zone $(terraform output distributed-email-pipeline_zone)
