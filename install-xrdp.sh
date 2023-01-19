#!/bin/bash

# update repo
sudo apt-get update

# install xfce4
sudo apt-get -y install xfce4
sudo apt-get -y install xfce4-session

# install xrdp
sudo apt-get -y install xrdp

# add xrdp to ssl-cert
sudo adduser xrdp ssl-cert

# set xfce as a session
echo xfce4-session > ~/.xsession

# restart xrdp
sudo systemctl restart xrdp
