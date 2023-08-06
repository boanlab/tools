#!/bin/bash

if [ ! -f /usr/local/bin/helm ]; then
  ../kubernetes/install-helm.sh
fi

helm repo add cilium https://helm.cilium.io
helm repo update
helm install tetragon cilium/tetragon -n kube-system
kubectl rollout status -n kube-system ds/tetragon -w
