#!/bin/bash

# set container runtime
if [ "$RUNTIME" == "" ]; then
    if [ -S /var/run/docker.sock ]; then
        RUNTIME="docker"

    elif [ -S /var/run/crio/crio.sock ]; then
        RUNTIME="crio"

    else # default
        RUNTIME="containerd"
    fi
fi

# create a single-node K3s cluster
if [ "$RUNTIME" == "docker" ]; then # docker
    CGROUP_SYSTEMD=$(docker info 2> /dev/null | grep -i cgroup | grep systemd | wc -l)
    if [ $CGROUP_SYSTEMD == 1 ]; then
        curl -sfL https://get.k3s.io | INSTALL_K3S_VERSION="v1.23.9+k3s1" K3S_KUBECONFIG_MODE="644" INSTALL_K3S_EXEC="--disable=traefik --docker --kubelet-arg cgroup-driver=systemd" sh -
        [[ $? != 0 ]] && echo "Failed to install k3s" && exit 1
    else # cgroupfs
        curl -sfL https://get.k3s.io | INSTALL_K3S_VERSION="v1.23.9+k3s1" K3S_KUBECONFIG_MODE="644" INSTALL_K3S_EXEC="--disable=traefik --docker" sh -
        [[ $? != 0 ]] && echo "Failed to install k3s" && exit 1
    fi
elif [ "$RUNTIME" == "crio" ]; then # cri-o
  curl -sfL https://get.k3s.io | K3S_KUBECONFIG_MODE="644" INSTALL_K3S_EXEC="--disable=traefik --container-runtime-endpoint unix:///var/run/crio/crio.sock --kubelet-arg cgroup-driver=systemd" sh -
  [[ $? != 0 ]] && echo "Failed to install k3s" && exit 1
else # use containerd by default
  curl -sfL https://get.k3s.io | K3S_KUBECONFIG_MODE="644" INSTALL_K3S_EXEC="--disable=traefik" sh -
  [[ $? != 0 ]] && echo "Failed to install k3s" && exit 1
fi

KUBEDIR=$HOME/.kube
KUBECONFIG=$KUBEDIR/config
[[ ! -d $KUBEDIR ]] && mkdir $KUBEDIR
if [ -f $KUBECONFIG ]; then
    echo "Found $KUBECONFIG already in place ... backing it up to $KUBECONFIG.backup"
    cp $KUBECONFIG $KUBECONFIG.backup
fi
sudo cp /etc/rancher/k3s/k3s.yaml $KUBECONFIG
sudo chown $USER:$USER $KUBECONFIG
echo "export KUBECONFIG=$KUBECONFIG" | tee -a ~/.bashrc

echo "wait for initialization"
sleep 15

runtime="15 minute"
endtime=$(date -ud "$runtime" +%s)

while [[ $(date -u +%s) -le $endtime ]]
do
    status=$(kubectl get pods -A -o jsonpath={.items[*].status.phase})
    [[ $(echo $status | grep -v Running | wc -l) -eq 0 ]] && break
    echo "wait for initialization"
    sleep 1
done

kubectl get pods -A

echo ">> Next Step <<"
echo "To deploy a CNI, run 'CNI={flannel|weave|calico|cilium} ./deploy-cni.sh'."
