#!/usr/bin/env bash

# cd to project root
cd "$(dirname "${0}")" || exit
cd ../

# Bring down Terraform
cd terraform
terraform destroy -auto-approve
