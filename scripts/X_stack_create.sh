#!/usr/bin/env bash

# cd to current folder
cd "$(dirname "${0}")" || exit

time ./1_stack_creation.sh
time ./2_kafka_deploy.sh
time ./3_crawler_deploy.sh
time ./4_spark_streaming_deploy.sh
time ./5_tensorflow_deploy.sh
time ./6_api_deploy.sh
