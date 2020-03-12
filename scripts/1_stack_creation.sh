#!/usr/bin/env bash

# cd to project root
cd "$(dirname "${0}")" || exit
cd ../

# Run Terraform
echo "Running Terraform to setup infrastructure."
cd terraform
terraform apply -auto-approve

# Setup env
echo "Setting up environment variables."
export PROJECT_ID=$(gcloud info --format='value(config.project)')
export ZONE=$(terraform output distributed-email-pipeline_zone)
export KAFKA_CLUSTER=$(terraform output kafka-cluster-name)
export CRAWLER_GENERATOR_CLUSTER=$(terraform output crawler-generator-cluster-name)
export STREAMING_CLUSTER=$(terraform output streaming-cluster-name)

# Setup Kubectx with Kubectl configs to ease switching.
echo "Creating Kubectx shortcuts for context switching."
gcloud container clusters get-credentials ${KAFKA_CLUSTER} --zone ${ZONE} --project ${PROJECT_ID}
gcloud container clusters get-credentials ${CRAWLER_GENERATOR_CLUSTER} --zone ${ZONE} --project ${PROJECT_ID}
gcloud container clusters get-credentials ${STREAMING_CLUSTER} --zone ${ZONE} --project ${PROJECT_ID}

kubectx kafka=gke_${PROJECT_ID}_${ZONE}_${KAFKA_CLUSTER}
kubectx crawler_generator=gke_${PROJECT_ID}_${ZONE}_${CRAWLER_GENERATOR_CLUSTER}
kubectx streaming=gke_${PROJECT_ID}_${ZONE}_${STREAMING_CLUSTER}

export ALL_CLUSTERS=(kafka crawler_generator streaming)

cd ../

# Setup Multi-cluster Istio with Replicated Control Planes.
# https://istio.io/docs/setup/install/multicluster/gateways/
# https://github.com/GoogleCloudPlatform/istio-samples/tree/master/multicluster-gke/dual-control-plane
ISTIO_VERSION=1.5.0
echo "Downloading Istio ${ISTIO_VERSION}."
curl -L https://git.io/getLatestIstio | ISTIO_VERSION=${ISTIO_VERSION} sh -

install_istio () {
    kubectl create clusterrolebinding cluster-admin-binding \
        --clusterrole=cluster-admin \
        --user="$(gcloud config get-value core/account)"
    kubectl create namespace istio-system

    # TODO: Remove usage of default certs - generate own.
    # TODO: Evaluate whether Vault can assist.
    kubectl create secret generic cacerts -n istio-system \
        --from-file=istio-${ISTIO_VERSION}/samples/certs/ca-cert.pem \
        --from-file=istio-${ISTIO_VERSION}/samples/certs/ca-key.pem \
        --from-file=istio-${ISTIO_VERSION}/samples/certs/root-cert.pem \
        --from-file=istio-${ISTIO_VERSION}/samples/certs/cert-chain.pem

    ./istio-${ISTIO_VERSION}/bin/istioctl manifest apply -f istio/values-istio-multicluster-gateways.yaml
}

for CLUSTER in ${ALL_CLUSTERS[@]}; do
    echo "Installing Istio on ${CLUSTER} cluster."
    kubectl config use-context ${CLUSTER}
    install_istio
done

# Setup KubeDNS on clusters
configure_dns () {
    export GLOBAL_DNS=$(kubectl get svc -n istio-system istiocoredns -o jsonpath='{.spec.clusterIP}')
    echo "Global DNS: ${GLOBAL_DNS}"
    kubectl apply -f - <<EOF
apiVersion: v1
kind: ConfigMap
metadata:
  name: kube-dns
  namespace: kube-system
data:
  stubDomains: |
    {"global": ["${GLOBAL_DNS}"]}
EOF
}

for CLUSTER in ${ALL_CLUSTERS[@]}; do
    echo "Setting up DNS on ${CLUSTER} cluster."
    kubectl config use-context ${CLUSTER}
    configure_dns
done

# Await ingress IP assignment
sleep 15

# Get Istio Gateway IPs
kubectl config use-context kafka
export KAFKA_GW=$(kubectl get -n istio-system service istio-ingressgateway -o jsonpath='{.status.loadBalancer.ingress[0].ip}')
echo "Kafka Gateway IP: ${KAFKA_GW}."

kubectl config use-context crawler_generator
export CRAWLER_GENERATOR_GW=$(kubectl get -n istio-system service istio-ingressgateway -o jsonpath='{.status.loadBalancer.ingress[0].ip}')
echo "Crawler/Generator Gateway IP: ${CRAWLER_GENERATOR_GW}."

kubectl config use-context streaming
export STREAMING_GW=$(kubectl get -n istio-system service istio-ingressgateway -o jsonpath='{.status.loadBalancer.ingress[0].ip}')
echo "Streaming Gateway IP: ${STREAMING_GW}."

# Now, the clusters can communicate with each other.
echo "Finished creating and provisioning infrastructure"
