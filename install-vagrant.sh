#!/bin/bash

. /etc/os-release

if [ "$NAME" != "Ubuntu" ]; then
    echo "This script is for Ubuntu."
    exit
fi

if [ ! -x "$(command -v vagrant)" ]; then
    # update repo
    sudo apt-get update

    # install vagrant
    sudo apt-get install -y vagrant
else
    echo "Found Vagrant, skipping the installation of Vagrant."
fi
