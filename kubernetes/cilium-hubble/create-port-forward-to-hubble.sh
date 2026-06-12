#!/bin/bash

# Expose the Hubble UI on port 12000 for remote access.
kubectl port-forward -n kube-system svc/hubble-ui --address 0.0.0.0 12000:80
