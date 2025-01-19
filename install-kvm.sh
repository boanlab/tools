#!/bin/bash

. /etc/os-release

if [ "$NAME" != "Ubuntu" ]; then
    echo "This script is for Ubuntu."
    exit
fi

if [ ! -x "$(command -v kvm)" ]; then
    # update repo
    sudo apt-get update

    # install kvm and dependencies
    sudo apt-get install -y bridge-utils libguestfs-tools libvirt-daemon-system \
                            libvirt-clients libvirt-daemon libvirt-dev \
                            qemu-system qemu-kvm virt-manager
else
    echo "Found KVM, skipping the installation of KVM."
fi
