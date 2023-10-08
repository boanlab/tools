# Tools

- Ubuntu
    - upgrade-ubuntu.sh
    - install-net-tools.sh
    - install-nfs-client.sh
    - install-kvm.sh
    - install-virtualbox.sh
    - install-vagrant.sh
    - set-cpu-mode.sh
    - desktop
        - install-ubuntu-desktop.sh
        - install-xrdp.sh
        - install-hangul.sh
        - install-chrome.sh

- languages
    - install-gcc.sh
    - install-java.sh
    - install-golang.sh

- containers
    - install-docker.sh
    - install-containerd.sh

- kubernetes
    - install-minikube.sh
    - install-microk8s.sh
    - install-k3s.sh (-> deploy-cni.sh)
    - install-kubeadm.sh (-> initialize-kubeadm.sh)
    - MULTI={true|false} initialize-kubeadm.sh (-> deploy-cni.sh)
    - CNI={flannel|weave|calico|cilium} deploy-cni.sh
    - cilium-hubble/*
    - tetragon/*
