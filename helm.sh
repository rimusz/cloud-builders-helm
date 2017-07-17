#!/bin/bash

echo "Updating kubeconfig"
sed -i '/cmd-/d' /workspace/.kube/config

echo "Running: helm init --client-only"
helm init --client-only

# check if repo values provided then add that repo if it is
if [[ -z $HELM_REPO_NAME || -z $HELM_REPO_URL ]]; then
  echo "No Helm chart repo to add"
else
  echo "Adding Helm chart repo $HELM_REPO_URL "
  helm repo add $HELM_REPO_NAME $HELM_REPO_URL
fi

echo "Running: helm repo update"
helm repo update

echo "Running: helm $@"
helm "$@"
