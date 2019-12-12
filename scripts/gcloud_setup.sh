#!/usr/bin/env bash

# shellcheck disable=SC2088
export GOOGLE_CLOUD_KEYFILE_JSON="~/.terraform/config.json"
gcloud config set project distributed-nlp-emails
