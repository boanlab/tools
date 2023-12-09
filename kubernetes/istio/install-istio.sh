#!/bin/bash

if [ ! -f /usr/local/bin/istioctl ]; then
    echo "istioctl is not found."
    exit
fi

# install istio
istioctl install
