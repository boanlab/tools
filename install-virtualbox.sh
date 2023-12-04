#!/bin/bash

. /etc/os-release

if [ "$NAME" != "Ubuntu" ]; then
    echo "This script is for Ubuntu."
    exit
fi

if [ ! -x "$(command -v vboxmanage)" ]; then
    # install wget
    sudo apt-get -y install wget

    # download oracle_vbox_2016.asc and register it to the system
    wget -O- https://www.virtualbox.org/download/oracle_vbox_2016.asc | sudo gpg --dearmor --yes --output /usr/share/keyrings/oracle-virtualbox-2016.gpg

    # install vbox
    sudo apt-get update
    sudo apt-get install virtualbox-6.1

    echo "Please reboot the machine."
else
    echo "Found VirtualBox, skipping the installation of Virtualbox."
fi
