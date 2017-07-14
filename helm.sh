#!/bin/sh

echo "Updating kubeconfig"
sed -i '/cmd-/d' /workspace/.kube/config

echo "Running: helm init --client-only"
helm init --client-only

echo "Adding chart helm repo"
# Update the command below with your Helm repo if you want
# it automaticly be available for use in pipeline steps
helm repo add rimusz https://rimusz.github.io/charts/

echo "Running: helm repo update"
helm repo update

echo "Running: helm $@"
helm "$@"
