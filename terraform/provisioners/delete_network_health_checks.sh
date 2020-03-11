#!/usr/bin/env bash
# Delete GCP created target pools.

CHECKS=($(gcloud compute http-health-checks list --format="table(name)"))
if ((${#CHECKS[@]})); then
    # Ignore first result as it's the column header - NAME
    gcloud compute http-health-checks delete -q ${CHECKS[@]:1}
fi
