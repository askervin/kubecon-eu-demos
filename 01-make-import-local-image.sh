#!/bin/bash

IMAGE=local/tf-cpu:latest

set -e -x

# Build (or rebuild) container image
docker build . -t "$IMAGE"

# Export built image from docker
docker save "$IMAGE" -o image.tar

# Import image to containerd image namespace that is visible to Kubernetes containers
sudo ctr -n k8s.io images import image.tar

# Create a pod yaml that uses the local image imported above
sed -e "s|image: \(.*\)|image: $IMAGE|g" < workload.yaml > workload-local.yaml

