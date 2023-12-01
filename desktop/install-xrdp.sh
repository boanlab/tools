#!/bin/bash

. /etc/os-release

if [ "$NAME" != "Ubuntu" ]; then
    echo "This script is for Ubuntu."
    exit
fi

# update repo
sudo apt-get update

# install xrdp and xfce4
sudo apt-get -y install xrdp xfce4

# set xfce as a session
sudo sed -i '/Xsession/s/^/#/' /etc/xrdp/startwm.sh
echo "test -x /usr/bin/startxfce4 && exec /usr/bin/startxfce4" | sudo tee -a /etc/xrdp/startwm.sh
echo "exec /bin/sh /usr/bin/startxfce4" | sudo tee -a /etc/xrdp/startwm.sh

# enable xrdp
sudo systemctl enable xrdp

# restart xrdp
sudo systemctl restart xrdp
