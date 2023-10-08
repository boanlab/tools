#!/bin/bash

. /etc/os-release

if [ "$NAME" != "Ubuntu" ]; then
    echo "This script is for Ubuntu."
    exit
fi

# install kvm and dependencies
sudo apt-get install -y bridge-utils libguestfs-tools \
                        libvirt-daemon-system libvirt-clients libvirt-daemon libvirt-dev \
                        qemu-system qemu-kvm virt-manager
