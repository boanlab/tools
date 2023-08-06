#!/bin/bash

# create a port forward to the hubble service (local access)
#cilium hubble port-forward

# create a port forward to the hubble service (remote access)
kubectl port-forward -n kube-system svc/hubble-ui --address 0.0.0.0 12000:80
