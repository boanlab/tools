#!/bin/bash

# install curl
sudo apt-get -y install curl

# download helm script
curl -fsSL -o get_helm.sh https://raw.githubusercontent.com/helm/helm/main/scripts/get-helm-3

# install helm
bash ./get_helm.sh

# remove helm script
rm ./get_helm.sh
