#!/usr/bin/env bash
# Delete GCP created target pools.

POOLS=($(gcloud compute target-pools list --format="table(name)"))
if ((${#POOLS[@]})); then
    # Ignore first result as it's the column header - NAME
    gcloud compute target-pools delete --region us-east1 -q ${POOLS[@]:1}
fi
