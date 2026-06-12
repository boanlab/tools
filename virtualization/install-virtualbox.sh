#!/bin/bash

. /etc/os-release

if [ "$NAME" != "Ubuntu" ]; then
    echo "This script is for Ubuntu."
    exit
fi

if [ ! -x "$(command -v vboxmanage)" ]; then
    # update repo
    sudo apt-get update

    # install vbox
    sudo apt-get install -y virtualbox

    echo "Please reboot the machine."
else
    echo "Found VirtualBox, skipping the installation of Virtualbox."
fi
