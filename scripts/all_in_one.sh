#!/usr/bin/env bash

# cd to project root
cd "$(dirname "${0}")" || exit
cd ../

# Setup cluster (Terraform)
./scripts/stack_creation.sh

# Setup Kafka
./scripts/kafka_deploy.sh

# Setup Credentials
kubectl create secret docker-registry gcr-cred \
    --docker-server=https://gcr.io \
    --docker-username=_json_key \
    --docker-password="$(cat ~/.config/gcloud/gcp_service_account.json)" \
    --docker-email=terraform@distributed-email-pipeline.iam.gserviceaccount.com

# Setup event producers (Crawler & Generator)
./scripts/crawler_deploy.sh
./scripts/generator_deploy.sh

# Setup event consumers (Spark Streaming)
