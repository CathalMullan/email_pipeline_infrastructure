#!/usr/bin/env bash

# cd to current folder
cd "$(dirname "${0}")" || exit

time ./1_stack_creation.sh
time ./2_kafka_deploy.sh
time ./3_crawler_deploy.sh
