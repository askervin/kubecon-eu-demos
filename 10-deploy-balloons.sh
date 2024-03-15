#!/bin/bash

set -e -x

# Add nri-plugins helm repository if not already there.
helm -n kube-system list | grep balloons || \
	helm repo add nri-plugins https://containers.github.io/nri-plugins

# Install the balloons resource policy from the nri-plugins repository.
helm install balloons nri-plugins/nri-resource-policy-balloons --namespace kube-system

# Replace the default balloons configuration that comes from the repository
# with a custom policy.
kubectl delete -n kube-system balloonspolicies --all
kubectl create -n kube-system -f default.balloonspolicy.yaml
