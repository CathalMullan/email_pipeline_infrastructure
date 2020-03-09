# Kube Network Debug
Standard procedure to follow when debugging network related problems

## Prerequisites
* Connection to Kubernetes cluster

## Using Debug Pod
Create a basic Ubuntu pod within the cluster.

```
kubectl run debug --image=ubuntu:xenial -- bash -c "sleep 1000000000;"
```

Connect to it

```
kubectl exec -it deployment/debug -- /bin/bash
```

Install `telnet`, `dig`, `ping`

```
apt-get -y update
apt-get -y install telnet dnsutils iputils-ping
```

Attempt to ping the ip of another resource

```
ping ...
```

```
telnet ...
```

Or view the addresses of instances

```
dig kafka-cluster-kafka-0.kafka-cluster-kafka-brokers.kafka.svc.local.cluster
```

## Tidy Up
Remember to delete your pod

```
kubectl delete deployment/debug
```
