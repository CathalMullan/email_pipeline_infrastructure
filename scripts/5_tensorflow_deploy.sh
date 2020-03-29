#!/usr/bin/env bash

# cd to project root
cd "$(dirname "${0}")" || exit
cd ../

## Create namespace.
#kubectl config use-context tensorflow
#kubectl create namespace tensorflow
#kubectl config set-context --current --namespace tensorflow
#
## Install Spark-on-K8s operator.
#helm repo add incubator http://storage.googleapis.com/kubernetes-charts-incubator
#
#kubectl create namespace spark-operator
#helm install incubator/sparkoperator \
#    --generate-name \
#    --namespace spark-operator \
#    --set sparkJobNamespace=tensorflow \
#    --wait
