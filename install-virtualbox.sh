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
    echo "deb [arch=amd64 signed-by=/usr/share/keyrings/oracle_vbox_2016.gpg] http://download.virtualbox.org/virtualbox/debian $(lsb_release -sc) contrib" | sudo tee /etc/apt/sources.list.d/virtualbox.list

    # install virtualbox
    sudo apt-get update
    sudo apt-get -y install virtualbox

    echo "Please reboot the machine."
else
    echo "Found VirtualBox, skipping the installation of Virtualbox"
fi
