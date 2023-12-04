#!/bin/bash

. /etc/os-release

if [ "$NAME" != "Ubuntu" ]; then
    echo "This script is for Ubuntu."
    exit
fi

if [ ! -x "$(command -v vagrant)" ]; then
    VAGRANT_VERSION=2.3.0

    # install wget
    sudo apt-get -y install wget

    # download vagrant package
    wget https://releases.hashicorp.com/vagrant/$VAGRANT_VERSION/vagrant_$VAGRANT_VERSION-1_amd64.deb

    # install vagrant
    sudo apt -y install ./vagrant_$VAGRANT_VERSION-1_amd64.deb

    # rm the vagrant package
    rm vagrant_$VAGRANT_VERSION-1_amd64.deb
else
    echo "Found Vagrant, skipping the installation of Vagrant."
fi

# install vagrant plugins
vagrant plugin install vagrant-vbguest
vagrant plugin install vagrant-reload
