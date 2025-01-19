#!/bin/bash

# set default
if [ "$CNI" == "" ]; then
    echo "Usage: CNI={flannel|calico|cilium} $0"
    exit
fi

# check supported CNI
if [ "$CNI" != "flannel" ] && [ "$CNI" != "calico" ] && [ "$CNI" != "cilium" ]; then
    echo "Usage: CNI={flannel|calico|cilium} $0"
    exit
fi

if [ "$CNI" == "flannel" ]; then
    # install a pod network (flannel)
    kubectl apply -f https://github.com/flannel-io/flannel/releases/latest/download/kube-flannel.yml
elif [ "$CNI" == "calico" ]; then
    # install a pod network (calico)
    kubectl apply -f https://raw.githubusercontent.com/projectcalico/calico/v3.29.0/manifests/calico.yaml
elif [ "$CNI" == "cilium" ]; then
    # install a pod network (cilium)
    curl -LO https://github.com/cilium/cilium-cli/releases/latest/download/cilium-linux-amd64.tar.gz
    sudo tar xzvfC cilium-linux-amd64.tar.gz /usr/local/bin
    rm cilium-linux-amd64.tar.gz
    /usr/local/bin/cilium install
fi
