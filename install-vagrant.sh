#!/bin/bash

. /etc/os-release

if [ "$NAME" != "Ubuntu" ]; then
    echo "This script is for Ubuntu."
    exit
fi

if [ ! -x "$(command -v vboxmanage)" ]; then
    # install repository keys
    wget -O- https://www.virtualbox.org/download/oracle_vbox_2016.asc | sudo gpg --dearmor -o /usr/share/keyrings/oracle_vbox_2016.gpg
    curl https://www.virtualbox.org/download/oracle_vbox.asc | sudo gpg --dearmor -o /usr/share/keyrings/oracle_vbox.gpg

    # add virtualbox repository
    echo "deb [arch=amd64] http://download.virtualbox.org/virtualbox/debian $(lsb_release -sc) contrib" | sudo tee /etc/apt/sources.list.d/virtualbox.list

    # install virtualbox
    sudo apt-get update
    sudo apt-get -y install virtualbox
else
    echo "Found VirtualBox, skipping the installation of Virtualbox"
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

echo "Please reboot the machine."
