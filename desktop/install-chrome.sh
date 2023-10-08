#!/bin/bash

. /etc/os-release

if [ "$NAME" != "Ubuntu" ]; then
    echo "This script is for Ubuntu."
    exit
fi

# update repo
sudo apt-get update

# install wget
sudo apt-get -y install wget

# download chrome package
sudo wget https://dl.google.com/linux/direct/google-chrome-stable_current_amd64.deb

# install chrome
sudo apt-get -y install ./google-chrome-stable_current_amd64.deb

# remove chrome package
sudo rm google-chrome-stable_current_amd64.deb
