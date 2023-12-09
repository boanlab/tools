#!/bin/bash

if [ -z $1 ]; then
    echo "$0 [namespace]"
    exit
fi

# check if namespace exists
kubectl get namespace $1 > /dev/null 2>&1
if [ $? != 0 ]; then
    echo "$1 is not found."
    exit
fi

# add istio-injection=enabled
kubectl label namespace $1 istio-injection=enabled --overwrite

# check the istio-injection label
kubectl get namespace $1 -L istio-injection
