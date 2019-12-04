#!/usr/bin/env bash
# Setup our configurations for Google Cloud Platform tool gcloud

# shellcheck disable=SC2088
export GOOGLE_CLOUD_KEYFILE_JSON="~/.terraform/config.json"

gcloud config set project distributed-nlp-emails
gcloud config set compute/zone us-east1-a
