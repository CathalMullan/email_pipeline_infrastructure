#!/usr/bin/env bash
# Delete GCP created forwarding rules.

RULES=($(gcloud compute forwarding-rules list --format="table(name)"))
if ((${#RULES[@]})); then
    # Ignore first result as it's the column header - NAME
    gcloud compute forwarding-rules delete --region us-east1 -q ${RULES[@]:1}
fi
