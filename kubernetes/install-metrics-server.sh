#!/bin/bash

# original installation
#kubectl apply -f https://github.com/kubernetes-sigs/metrics-server/releases/latest/download/components.yaml

# custom installation
kubectl apply -f metrics-server.yaml
