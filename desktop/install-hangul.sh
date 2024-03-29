#!/bin/bash

. /etc/os-release

if [ "$NAME" != "Ubuntu" ]; then
    echo "This script is for Ubuntu."
    exit
fi

# update repo
sudo apt-get update

# install language pack
sudo apt-get -y install language-pack-ko

# install nanum font
sudo apt-get -y install fonts-nanum fonts-nanum-coding fonts-nanum-extra
