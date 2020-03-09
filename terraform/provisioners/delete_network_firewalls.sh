#!/usr/bin/env bash
# Delete GCP created firewalls.

FIREWALLS=($(gcloud compute firewall-rules list --filter NETWORK=project-network --format="table(name)"))
if ((${#FIREWALLS[@]})); then
    # Ignore first result as it's the column header - NAME
    gcloud compute firewall-rules delete -q ${FIREWALLS[@]:1}
fi
