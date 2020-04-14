#!/usr/bin/env bash

# cd to project root
cd "$(dirname "${0}")" || exit
cd ../

# Create namespace.
kubectl config use-context tensorflow
kubectl create namespace mpi-operator
kubectl config set-context --current --namespace mpi-operator

# Install NVIDIA drivers on Container-Optimized OS with plugins.
kubectl apply -f https://raw.githubusercontent.com/GoogleCloudPlatform/container-engine-accelerators/master/nvidia-driver-installer/cos/daemonset-preloaded.yaml

# Deploy MPI operator.
kubectl apply -f kubernetes/tensorflow/mpi_operator.yaml

# Secret to allow GS connectivity.
kubectl create secret generic service-account --from-file=/Users/cmullan/.config/gcloud/gcp_service_account.json

# Schedule jobs.
kubectl create secret generic topic-model-job --from-file=kubernetes/tensorflow/topic_model_job.yaml
kubectl apply -f kubernetes/tensorflow/cron_topic_model.yaml

#kubectl create job --from=cronjob/topic-model-cron topic-cron-1
#kubectl wait --for=condition=complete --timeout=6000s job/topic-model-launcher
#kubectl delete mpijobs.kubeflow.org topic-model && kubectl delete jobs.batch topic-cron-1

kubectl create secret generic summarization-job --from-file=kubernetes/tensorflow/summarization_job.yaml
kubectl apply -f kubernetes/tensorflow/cron_summarization.yaml

#kubectl create job --from=cronjob/summarization-cron summarization-cron-1
#kubectl wait --for=condition=complete --timeout=6000s job/summarization-launcher
#kubectl delete mpijobs.kubeflow.org summarization && kubectl delete jobs.batch summarization-cron-1
