#!/usr/bin/env bash

# cd to project root
cd "$(dirname "${0}")" || exit
cd ../

# Run Terraform
echo "Running Terraform to setup infrastructure."
cd terraform
terraform apply -auto-approve

# Setup env
echo "Setting up environment variables."
export PROJECT_ID=$(gcloud info --format='value(config.project)')
export ZONE=$(terraform output distributed-email-pipeline_zone)
export KAFKA_CLUSTER=$(terraform output kafka-cluster-name)
export CRAWLER_GENERATOR_CLUSTER=$(terraform output crawler-generator-cluster-name)
export STREAMING_CLUSTER=$(terraform output streaming-cluster-name)

# Setup Kubectx with Kubectl configs to ease switching.
echo "Creating Kubectx shortcuts for context switching."
gcloud container clusters get-credentials ${KAFKA_CLUSTER} --zone ${ZONE} --project ${PROJECT_ID}
gcloud container clusters get-credentials ${CRAWLER_GENERATOR_CLUSTER} --zone ${ZONE} --project ${PROJECT_ID}
gcloud container clusters get-credentials ${STREAMING_CLUSTER} --zone ${ZONE} --project ${PROJECT_ID}

kubectx kafka=gke_${PROJECT_ID}_${ZONE}_${KAFKA_CLUSTER}
kubectx crawler_generator=gke_${PROJECT_ID}_${ZONE}_${CRAWLER_GENERATOR_CLUSTER}
kubectx streaming=gke_${PROJECT_ID}_${ZONE}_${STREAMING_CLUSTER}

export ALL_CLUSTERS=(kafka crawler_generator streaming)

cd ../

# Now, the clusters can communicate with each other.
echo "Finished creating and provisioning infrastructure"
