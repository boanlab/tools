#!/bin/bash

. /etc/os-release

if [ "$NAME" != "Ubuntu" ]; then
    echo "This script is for Ubuntu."
    exit
fi

# check container runtime
if [ ! -S /var/run/containerd/containerd.sock ]; then
    echo "containerd is not detected."
    echo "To install containerd, run '../containers/install-containerd.sh'."
    exit 1
fi

# update repo
sudo apt-get update

# install prerequisites
sudo apt-get install -y curl ca-certificates apt-transport-https gpg

# resolve version
# usage: VERSION=1.33        ./install-kubeadm.sh   (latest patch on 1.33)
#        VERSION=1.33.0      ./install-kubeadm.sh   (specific patch)
#        VERSION=1.33.2-1.1  ./install-kubeadm.sh   (specific deb revision)
#        (no VERSION)        ./install-kubeadm.sh   (latest stable)
if [ -z "$VERSION" ]; then
    LATEST=$(curl -L -s https://dl.k8s.io/release/stable.txt | sed 's/^v//')
    if [ -z "$LATEST" ]; then
        echo "Failed to fetch the latest Kubernetes version."
        exit 1
    fi
    MINOR=$(echo "$LATEST" | cut -d. -f1,2)
    PKG_SPEC=""
    echo "Installing the latest Kubernetes (v$LATEST)."
else
    CLEAN=$(echo "$VERSION" | sed 's/^v//')
    MINOR=$(echo "$CLEAN" | cut -d. -f1,2)
    # if user only gave minor (e.g. 1.33), let apt pick the latest patch
    if [ "$CLEAN" = "$MINOR" ]; then
        PKG_SPEC=""
        echo "Installing the latest patch of Kubernetes v$MINOR."
    else
        # append default deb revision if missing
        if echo "$CLEAN" | grep -q -- '-'; then
            DEB_VERSION="$CLEAN"
        else
            DEB_VERSION="${CLEAN}-1.1"
        fi
        PKG_SPEC="=$DEB_VERSION"
        echo "Installing Kubernetes v$CLEAN."
    fi
fi

# add the key for the kubernetes repo
sudo mkdir -p /etc/apt/keyrings
sudo rm -f /etc/apt/keyrings/kubernetes-apt-keyring.gpg
curl -fsSL "https://pkgs.k8s.io/core:/stable:/v${MINOR}/deb/Release.key" \
    | sudo gpg --dearmor -o /etc/apt/keyrings/kubernetes-apt-keyring.gpg

# add sources.list.d
echo "deb [signed-by=/etc/apt/keyrings/kubernetes-apt-keyring.gpg] https://pkgs.k8s.io/core:/stable:/v${MINOR}/deb/ /" \
    | sudo tee /etc/apt/sources.list.d/kubernetes.list

# update repo
sudo apt-get update

# install kubernetes
sudo apt-get install -y "kubeadm${PKG_SPEC}" "kubelet${PKG_SPEC}" "kubectl${PKG_SPEC}"

# exclude kubernetes packages from updates
sudo apt-mark hold kubeadm kubelet kubectl

# mount bpffs (for cilium)
if ! grep -q "^bpffs" /etc/fstab; then
    echo "bpffs                                     /sys/fs/bpf     bpf     defaults          0       0" | sudo tee -a /etc/fstab
fi

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
echo "To initialize Kubernetes, run '(MULTI=true) ./initialize-kubeadm.sh'"
