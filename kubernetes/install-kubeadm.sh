#!/bin/bash

if [ "$RUNTIME" == "" ]; then
    if [ -S /var/run/docker.sock ]; then
        RUNTIME="docker"
    elif [ -S /var/run/cri-dockerd.sock ]; then
	RUNTIME="cri-docker"
    elif [ -S /var/run/crio/crio.sock ]; then
        RUNTIME="crio"
    else # default
        RUNTIME="containerd"
    fi
fi

# update repo
sudo apt-get update

# install apt-transport-https
sudo apt-get install -y apt-transport-https ca-certificates curl

# add the key for kubernetes repo
sudo curl -fsSL https://packages.cloud.google.com/apt/doc/apt-key.gpg | sudo gpg --dearmor -o /etc/apt/keyrings/kubernetes-archive-keyring.gpg

# add sources.list.d
echo "deb [signed-by=/etc/apt/keyrings/kubernetes-archive-keyring.gpg] https://apt.kubernetes.io/ kubernetes-xenial main" | sudo tee /etc/apt/sources.list.d/kubernetes.list

# update repo
sudo apt-get update

# install kubernetes
if [ "$RUNTIME" == "docker" ]; then
    # install a specific version (v1.23.0)
    sudo apt-get install -y kubeadm=1.23.0-00 kubelet=1.23.0-00 kubectl=1.23.0-00

    # exclude kubernetes packages from updates
    sudo apt-mark hold kubeadm kubelet kubectl
else # otherwise
    # install the latest version
    sudo apt-get install -y kubeadm kubelet kubectl
fi

# mount bpffs (for cilium)
echo "bpffs                                     /sys/fs/bpf     bpf     defaults          0       0" | sudo tee -a /etc/fstab

# enable ip forwarding
if [ $(cat /proc/sys/net/ipv4/ip_forward) == 0 ]; then
    sudo bash -c "echo '1' > /proc/sys/net/ipv4/ip_forward"
    sudo bash -c "echo 'net.ipv4.ip_forward=1' >> /etc/sysctl.conf"
fi

# disable rp_filter
if [ ! -f /etc/sysctl.d/99-override_cilium_rp_filter.conf ]; then
    sudo bash -c "echo 'net.ipv4.conf.all.rp_filter = 0' > /etc/sysctl.d/99-override_cilium_rp_filter.conf"
    sudo systemctl restart systemd-sysctl
fi

