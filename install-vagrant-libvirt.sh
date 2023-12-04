#!/bin/bash

. /etc/os-release

if [ "$NAME" != "Ubuntu" ]; then
    echo "This script is for Ubuntu."
    exit
fi

if [ ! -x "$(command -v vagrant)" ]; then
    echo "Please install Vagrant first."
else
    # update repo
    sudo apt-get update

    # install build-essential
    sudo apt-get install -y build-essential

    # install vagrant-libvirt
    vagrant plugin install vagrant-libvirt
fi
