#!/bin/bash

# move to home
cd $HOME

# download istio
curl -L https://istio.io/downloadIstio | sh -

# copy istioctl to /usr/local/bin
sudo cp $HOME/istio-*/bin/istioctl /usr/local/bin
