#!/bin/bash

HUBBLE_VERSION=$(curl -s https://raw.githubusercontent.com/cilium/hubble/master/stable.txt)
HUBBLE_ARCH=amd64 # by default
if [ "$(uname -m)" = "aarch64" ]; then
    HUBBLE_ARCH=arm64;
fi

# download hubble client
curl -L --fail --remote-name-all https://github.com/cilium/hubble/releases/download/$HUBBLE_VERSION/hubble-linux-${HUBBLE_ARCH}.tar.gz{,.sha256sum}
sha256sum --check hubble-linux-${HUBBLE_ARCH}.tar.gz.sha256sum

# deploy hubble client
sudo tar xzvfC hubble-linux-${HUBBLE_ARCH}.tar.gz /usr/local/bin

# clean up files
rm hubble-linux-${HUBBLE_ARCH}.tar.gz{,.sha256sum}

