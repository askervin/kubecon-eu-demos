#!/bin/bash

set -e -x

helm uninstall balloons --namespace kube-system
kubectl delete -n kube-system balloonspolicies --all
