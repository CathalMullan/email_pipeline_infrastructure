#!/usr/bin/env bash
# Add visualization tool Kiali.

NAMESPACE=istio-system

kubectl config use-context kafka
kubectl create namespace ${NAMESPACE}
kubectl label namespace ${NAMESPACE} istio-injection=enabled
kubectl config set-context --current --namespace ${NAMESPACE}

KIALI_USERNAME=$(echo -n 'changeme' | base64)
KIALI_PASSPHRASE=$(echo -n 'changeme' | base64)

kubectl create namespace ${NAMESPACE}
cat <<EOF | kubectl apply -f -
apiVersion: v1
kind: Secret
metadata:
  name: kiali
  namespace: ${NAMESPACE}
  labels:
    app: kiali
type: Opaque
data:
  username: ${KIALI_USERNAME}
  passphrase: ${KIALI_PASSPHRASE}
EOF

istioctl manifest apply --set values.kiali.enabled=true
istioctl dashboard kiali

exit 0

# Cleanup Kiali
kubectl delete all,secrets,sa,configmaps,deployments,ingresses,clusterroles,clusterrolebindings,customresourcedefinitions --selector=app=kiali -n istio-system
