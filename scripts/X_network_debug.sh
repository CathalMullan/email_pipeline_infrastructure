#!/usr/bin/env bash
# Create a debug instance to verify mesh

# Switch context
CONTEXT=kafka
kubectl config use-context ${CONTEXT}
kubectl config set-context --current --namespace ${CONTEXT}

# Create Debug pod
kubectl run debug --image=ubuntu:xenial -- bash -c "sleep 1000000000;"
kubectl exec -it deployment/debug -- /bin/bash

apt-get -y update
apt-get -y install telnet dnsutils iputils-ping

exit 0

# Cleanup
kubectl delete deployment/debug
