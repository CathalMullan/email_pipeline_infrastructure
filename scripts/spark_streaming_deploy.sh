#!/usr/bin/env bash

# cd to project root
cd "$(dirname "${0}")" || exit
cd ../

# Create Namespace
cd kubernetes
kubectl create namespace streaming

# Deploy spark streaming cluster setup
kubectl apply -n streaming -f spark_streaming/

# DEBUG

# TODO
# Initiate streaming job
spark-submit \
    --master k8s://https://$(minikube ip):8443 \
    --name email_stream_processor \
    --deploy-mode cluster \
    --conf spark.executor.instances=2 \
    --conf spark.kubernetes.authenticate.driver.serviceAccountName=spark \
    --conf spark.kubernetes.container.image=docker pull gcr.io/distributed-email-pipeline/email_stream_processor:latest \
    --conf spark.kubernetes.namespace=spark \
    --packages org.apache.spark:spark-sql-kafka-0-10_2.12:3.0.0-preview2 \
    --conf spark.kubernetes.driver.secretKeyRef.KAFKA_HOSTS=kafka-secret:hosts \
    --conf spark.kubernetes.executor.secretKeyRef.KAFKA_HOSTS=kafka-secret:hosts \
    --conf spark.streaming.backpressure.enabled=true \
    /app/src/email_stream_processor/jobs/stream_pipeline.py
