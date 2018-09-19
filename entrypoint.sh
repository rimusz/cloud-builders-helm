#!/bin/bash

set -e

echo "Updating kubeconfig"
sed -i '/cmd-/d' /workspace/.kube/config

echo "Running: helm init --client-only"
helm init --client-only

# check if repo values provided then add that repo
if [[ -n $HELM_REPO_NAME && -n $HELM_REPO_URL ]]; then
  echo "Adding chart helm repo $HELM_REPO_URL "
  helm repo add $HELM_REPO_NAME $HELM_REPO_URL
fi

echo "Running: helm repo update"
helm repo update

# check if 'TILLERLESS=true' is provided then install and start the Tillerless  plugin
if [ "$TILLERLESS" = true ]; then
  echo "Installing Tillerless plugin"
  helm plugin install https://github.com/rimusz/helm-tiller
  echo "Starting Tillerless plugin"
  helm tiller start-ci "$TILLER_NAMESPACE"
  echo
  export HELM_HOST=localhost:44134
  if [ "$DEBUG" = true ]; then
      echo "Running: command $@"
  fi
  exec "$@"
  helm tiller stop
else
  if [ "$DEBUG" = true ]; then
      echo "Running: command $@"
  fi
  exec "$@"
fi
