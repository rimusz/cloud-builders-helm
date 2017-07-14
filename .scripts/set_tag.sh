#!/bin/bash

set -eo pipefail
#
TAG=$(cat TAG)
#
echo "Update Dockerfile with the tag ${TAG}"
sed -i "s/_RELEASE_/${TAG}/g" Dockerfile
#
echo "--- Done"
