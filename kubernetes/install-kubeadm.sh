#!/bin/bash

if [ "$RUNTIME" == "" ]; then
    if [ -S /var/run/cri-dockerd.sock ]; then
        RUNTIME="cri-docker"

    elif [ -S /var/run/docker.sock ]; then
        RUNTIME="docker"

    elif [ -S /var/run/crio/crio.sock ]; then
        RUNTIME="crio"

    elif [ -S /var/run/containerd/containerd.sock ]; then
        RUNTIME="containerd"

    else # default
        echo "Container Runtime is not detected."
        echo
        echo "To install Containerd, run '../containers/install-containerd.sh'."
        echo "To install Docker, run '../containers/install-docker.sh'."
        echo
        echo "Note that Kubernetes v1.23.0 would be installed if Docker is installed."
        echo "Otherwise, the latest version of Kubernetes would be installed."
        exit
    fi
fi

# update repo
sudo apt-get update

# install curl
sudo apt-get install -y curl

# install apt-transport-https
sudo apt-get install -y apt-transport-https ca-certificates gpg

# add the key for kubernetes repo
curl -fsSL https://pkgs.k8s.io/core:/stable:/v1.29/deb/Release.key | sudo gpg --dearmor -o /etc/apt/keyrings/kubernetes-apt-keyring.gpg

# add sources.list.d
echo 'deb [signed-by=/etc/apt/keyrings/kubernetes-apt-keyring.gpg] https://pkgs.k8s.io/core:/stable:/v1.29/deb/ /' | sudo tee /etc/apt/sources.list.d/kubernetes.list

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

# enable br_netfilter
sudo modprobe br_netfilter
if [ $(cat /proc/sys/net/bridge/bridge-nf-call-iptables) == 0 ]; then
    sudo bash -c "echo '1' > /proc/sys/net/bridge/bridge-nf-call-iptables"
    sudo bash -c "echo 'net.bridge.bridge-nf-call-iptables=1' >> /etc/sysctl.conf"
fi

# disable rp_filter
if [ ! -f /etc/sysctl.d/99-override_cilium_rp_filter.conf ]; then
    sudo bash -c "echo 'net.ipv4.conf.all.rp_filter = 0' > /etc/sysctl.d/99-override_cilium_rp_filter.conf"
    sudo systemctl restart systemd-sysctl
fi

echo ">> Next Step <<"
echo "To initialize Kubernetes, run 'MULTI={true|false} ./initialize-kubeadm.sh"
