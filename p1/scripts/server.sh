#!/usr/bin/env bash
set -e

apt-get update
apt-get install -y curl

# 644 pour autoriser user non root a lire le kubeconfig et pouvoir utiliser les commandes kubectl
curl -sfL https://get.k3s.io | \
  K3S_KUBECONFIG_MODE="644" \
  K3S_TOKEN="Tsais42" \
  INSTALL_K3S_EXEC="server --node-ip=192.168.56.110" \
  sh -