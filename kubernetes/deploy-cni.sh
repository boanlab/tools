#!/bin/bash

# set default
if [ "$CNI" == "" ]; then
    echo "Usage: CNI={flannel|weave|calico|cilium} $0"
    exit
fi

# check supported CNI
if [ "$CNI" != "flannel" ] && [ "$CNI" != "weave" ] && [ "$CNI" != "calico" ] && [ "$CNI" != "cilium" ]; then
    echo "Usage: CNI={flannel|weave|calico|cilium} $0"
    exit
fi

if [ "$CNI" == "flannel" ]; then
    # install a pod network (flannel)
    kubectl apply -f https://github.com/flannel-io/flannel/releases/latest/download/kube-flannel.yml
elif [ "$CNI" == "weave" ]; then
    # install a pod network (weave)
    kubectl apply -f https://github.com/weaveworks/weave/releases/download/v2.8.1/weave-daemonset-k8s.yaml
elif [ "$CNI" == "calico" ]; then
    # install a pod network (calico)
    kubectl create -f https://raw.githubusercontent.com/projectcalico/calico/v3.25.1/manifests/tigera-operator.yaml
    kubectl create -f https://raw.githubusercontent.com/projectcalico/calico/v3.25.1/manifests/custom-resources.yaml
elif [ "$CNI" == "cilium" ]; then
    # install a pod network (cilium)
    curl -LO https://github.com/cilium/cilium-cli/releases/latest/download/cilium-linux-amd64.tar.gz
    sudo tar xzvfC cilium-linux-amd64.tar.gz /usr/local/bin
    rm cilium-linux-amd64.tar.gz
    /usr/local/bin/cilium install
fi
