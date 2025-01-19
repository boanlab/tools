# Tools

- Ubuntu
    - upgrade-ubuntu.sh
    - install-net-tools.sh
    - install-nfs-client.sh
    - install-virtualbox.sh
    - install-vagrant.sh
    - install-kvm.sh
    - install-vagrant-libvirt.sh
    - desktop
        - install-xrdp.sh
        - install-ubuntu-desktop.sh
        - install-hangul.sh
        - install-chrome.sh

- languages
    - install-gcc.sh
    - install-java.sh
    - install-golang.sh
    - install-rust.sh

- containers
    - install-docker.sh
    - install-containerd.sh

- kubernetes
    - install-minikube.sh
    - install-microk8s.sh
    - install-k3s.sh (Next: deploy-cni.sh)
    - install-kubeadm.sh (Next: initialize-kubeadm.sh)
    - MULTI={true|false} initialize-kubeadm.sh (Next: deploy-cni.sh)
    - CNI={flannel|weave|calico|cilium} deploy-cni.sh
    - cilium-hubble/*
    - tetragon/*
