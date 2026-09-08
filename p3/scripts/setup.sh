#!/bin/bash

set -e

CLUSTER_NAME="iot"
ARGOCD_NAMESPACE="argocd"
DEV_NAMESPACE="dev"

echo "Creating K3d cluster..."

k3d cluster create "$CLUSTER_NAME"

echo "Creating namespaces..."

kubectl create namespace "$ARGOCD_NAMESPACE"
kubectl create namespace "$DEV_NAMESPACE"

echo "Installing Argo CD..."

kubectl apply \
  -n "$ARGOCD_NAMESPACE" \
  --server-side \
  --force-conflicts \
  -f https://raw.githubusercontent.com/argoproj/argo-cd/stable/manifests/install.yaml

echo "Waiting for Argo CD to be ready..."

kubectl wait \
  --for=condition=Available \
  deployment/argocd-server \
  -n "$ARGOCD_NAMESPACE" \
  --timeout=180s

kubectl wait \
  --for=condition=Available \
  deployment/argocd-repo-server \
  -n "$ARGOCD_NAMESPACE" \
  --timeout=180s

echo "Applying Argo CD Application..."

kubectl apply -f /home/vagrant/p3/confs/application.yaml

echo "Setup complete."