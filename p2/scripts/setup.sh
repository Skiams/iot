#!/usr/bin/env bash
set -e

echo "============================================="
echo "  Mise a jour du systeme et dependances...   "
echo "============================================="
export DEBIAN_FRONTEND=noninteractive
apt-get update -y
apt-get install -y curl

echo "============================================="
echo "       Installation de K3s (Server)...       "
echo "============================================="
curl -sfL https://get.k3s.io | \
  K3S_KUBECONFIG_MODE="644" \
  INSTALL_K3S_EXEC="server --node-ip=192.168.56.110" \
  sh -

echo "============================================="
echo "   Attente du statut Ready pour le noeud...  "
echo "============================================="
until kubectl get nodes | grep -q " Ready"; do
  echo "En attente de K3s..."
  sleep 2
done

echo "============================================="
echo " Application automatique des configurations "
echo "============================================="
kubectl apply -f /vagrant/confs/

echo "============================================="
echo "       Deploiement effectue avec succes !    "
echo "============================================="
