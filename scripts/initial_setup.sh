#!/usr/bin/env bash

# Setup Terraform credentials
PROJECT_ID="distributed-email-pipeline"

gcloud beta iam service-accounts create terraform \
    --description "Automated Deployment" \
    --display-name "terraform"

gcloud projects add-iam-policy-binding "${PROJECT_ID}" \
    --member="serviceAccount:terraform@${PROJECT_ID}.iam.gserviceaccount.com" \
    --role roles/owner

gcloud iam service-accounts keys create \
    ~/.config/gcloud/gcp_service_account.json \
    --iam-account "terraform@${PROJECT_ID}.iam.gserviceaccount.com"
