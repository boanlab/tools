#!/bin/bash

# set default
if [ "$CNI" == "" ]; then
    CNI=calico
fi

# use docker as default CRI
if [ "$CRI_SOCKET" == "" ]; then
    # if docker, let kubeadm figure it out
    if [ -S /var/run/docker.sock ]; then
        CRI_SOCKET=""
    elif [ -S /var/run/containerd/containerd.sock ]; then
        CRI_SOCKET=unix:///var/run/containerd/containerd.sock
    elif [ -S /var/run/crio/crio.sock ]; then
        CRI_SOCKET=unix:///var/run/crio/crio.sock
    fi
fi

# check supported CNI
if [ "$CNI" != "flannel" ] && [ "$CNI" != "weave" ] && [ "$CNI" != "calico" ] && [ "$CNI" != "cilium" ]; then
    echo "Usage: CNI={flannel|weave|calico|cilium} CRI_SOCKET=unix:///path/to/socket_file MULTI={true|false} $0"
    exit
fi

# check if k8s_init.log exists
if [ -f ~/k8s_init.log ]; then
    echo "Already tried to initialize kubeadm"
    exit
fi

# reload env
. ~/.bashrc

# turn off swap
sudo swapoff -a

# activate br_netfilter
sudo modprobe br_netfilter
sudo bash -c "echo '1' > /proc/sys/net/bridge/bridge-nf-call-iptables"
sudo bash -c "echo 'net.bridge.bridge-nf-call-iptables=1' >> /etc/sysctl.conf"

# initialize the master node
sudo kubeadm init --cri-socket=$CRI_SOCKET --pod-network-cidr=10.244.0.0/16 | tee -a ~/k8s_init.log

# stop if kubeadm fails
if [ $? != 0 ]; then
    echo "Failed to initialize kubeadm"
    exit
fi

# make kubectl work for non-root user
mkdir -p $HOME/.kube
sudo cp -i /etc/kubernetes/admin.conf $HOME/.kube/config
sudo chown $USER:$USER $HOME/.kube/config
export KUBECONFIG=$HOME/.kube/config
echo "export KUBECONFIG=$HOME/.kube/config" | tee -a ~/.bashrc

if [ "$MULTI" != "true" ]; then
    # disable master isolation (due to the lack of resources)
    kubectl taint nodes --all node-role.kubernetes.io/master-
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
