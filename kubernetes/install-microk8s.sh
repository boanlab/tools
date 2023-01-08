#!/bin/bash

. /etc/os-release

if [ "$NAME" != "Ubuntu" ]; then
    echo "This script is for Ubuntu."
    exit
fi

# update repo
sudo apt-get update

# install kernel-headers
sudo apt-get install -y linux-headers-$(uname -r)

# install microk8s
sudo snap install microk8s --classic

# check microk8s
sudo microk8s kubectl get nodes
sudo microk8s kubectl get services

# copy k8s config
mkdir -p $HOME/.kube
sudo microk8s kubectl config view --raw | sudo tee $HOME/.kube/config
sudo chown -R $USER: $HOME/.kube/

# download the latest kubectl
curl -LO "https://dl.k8s.io/release/$(curl -L -s https://dl.k8s.io/release/stable.txt)/bin/linux/amd64/kubectl"

# install kubectl
sudo mv kubectl /usr/bin
sudo chmod 755 /usr/bin/kubectl

# check kubectl
kubectl cluster-info
