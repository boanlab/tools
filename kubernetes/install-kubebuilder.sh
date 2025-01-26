#!/bin/bash

if [ ! -x "$(command -v kubebuilder)" ]; then
    # install kubebuilder
    curl -L -o kubebuilder "https://go.kubebuilder.io/dl/latest/$(go env GOOS)/$(go env GOARCH)"
    chmod +x kubebuilder && sudo mv kubebuilder /usr/local/bin/
else
    echo "Found KubeBuilder, skipping the installation of KubeBuilder"
fi

if [ ! -x "$(command -v kustomize)" ]; then
    # install kustomize
    curl -s "https://raw.githubusercontent.com/kubernetes-sigs/kustomize/master/hack/install_kustomize.sh"  | bash
    chmod +x kustomize && sudo mv kustomize /usr/local/bin/
else
    echo "Found Kustomize, skipping the installation of Kustomize"
fi
