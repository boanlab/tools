#!/bin/bash

. /etc/os-release

if [ "$NAME" != "Ubuntu" ]; then
    echo "This script is for Ubuntu."
    exit
fi

if [ ! -x "$(command -v vagrant)" ]; then
    # install vagrant key
    wget -O- https://apt.releases.hashicorp.com/gpg | sudo gpg --dearmor -o /usr/share/keyrings/hashicorp-archive-keyring.gpg

    # add vagrant repository
    echo "deb [signed-by=/usr/share/keyrings/hashicorp-archive-keyring.gpg] https://apt.releases.hashicorp.com $(lsb_release -cs) main" | sudo tee /etc/apt/sources.list.d/hashicorp.list

    # install vagrant
    sudo apt update
    sudo apt install vagrant
else
    echo "Found Vagrant, skipping the installation of Vagrant"
fi

# install vagrant plugins
vagrant plugin install vagrant-vbguest
vagrant plugin install vagrant-reload
