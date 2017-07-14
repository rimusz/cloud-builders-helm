#!/bin/sh

echo "Updating kubeconfig"
sed -i '/cmd-/d' /workspace/.kube/config

echo "Running: helm init --client-only"
helm init --client-only

# Uncomment this line and update with your Helm repo if you want
# it automaticly be available for use in pipeline steps
#echo "Adding your chart helm repo"
#helm repo add some-repo https://some-repo-charts.storage.googleapis.com

echo "Running: helm repo update"
helm repo update

echo "Running: helm $@"
helm "$@"
