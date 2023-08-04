#!/bin/bash

# check if planning to use multi nodes
if [ "$MULTI" != "true" ] && [ "$MULTI" != "false" ]; then
    echo "Usage: MULTI={true|false} $0"
    exit
fi

# check if k8s_init.log exists
if [ -f ~/k8s_init.log ]; then
    echo "Already tried to initialize kubeadm"
    exit
fi

# turn off swap
sudo swapoff -a
sudo sed -i '/ swap / s/^\(.*\)$/#\1/g' /etc/fstab

# enable br_netfilter
sudo modprobe br_netfilter
if [ $(cat /proc/sys/net/bridge/bridge-nf-call-iptables) == 0 ]; then
    sudo bash -c "echo '1' > /proc/sys/net/bridge/bridge-nf-call-iptables"
    sudo bash -c "echo 'net.bridge.bridge-nf-call-iptables=1' >> /etc/sysctl.conf"
fi

# initialize the master node
sudo kubeadm init --pod-network-cidr=10.244.0.0/16 | tee -a ~/k8s_init.log
if [ $? != 0 ]; then
    echo "Failed to initialize kubeadm"
    exit
fi

# make kubectl work for non-root user
if [ ! -f $HOME/.kube/config ]; then
    mkdir -p $HOME/.kube
    sudo cp -i /etc/kubernetes/admin.conf $HOME/.kube/config
    sudo chown $USER:$USER $HOME/.kube/config
    export KUBECONFIG=$HOME/.kube/config
    echo "export KUBECONFIG=$HOME/.kube/config" | tee -a ~/.bashrc
fi

# disable master isolation (due to the lack of resources)
if [ "$MULTI" != "true" ]; then
    kubectl taint nodes --all node-role.kubernetes.io/master-
fi

# sudo kubeadm token create --print-join-command

echo ">> Next Step <<"
echo "To deploy a CNI, run 'CNI={flannel|weave|calico|cilium} ./deploy-cni.sh'."
echo "If you see the error 'bridge-nf-call-iptables does not exist' when executing 'kubectl join' on worker nodes,"
echo "you can first run './enable-bridge-nf-call-iptables.sh' on worker nodes to fix this error."
