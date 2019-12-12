#!/usr/bin/env bash

# Don't run as a script - follow like a runbook!
exit 0

cd terraform || exit

terraform destroy -auto-approve
