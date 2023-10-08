#!/bin/bash

. /etc/os-release

if [ "$NAME" != "Ubuntu" ]; then
    echo "This script is for Ubuntu."
    exit
fi

# update repo
sudo apt-get update

# install wget
sudo apt -y install wget

# instsall golang
goBinary=$(curl -s https://go.dev/dl/ | grep linux | head -n 1 | cut -d'"' -f4 | cut -d"/" -f3)
wget https://dl.google.com/go/$goBinary -O /tmp/$goBinary
sudo tar -C /usr/local -xvzf /tmp/$goBinary
rm /tmp/$goBinary

# add GOPATH, GOROOT
echo >> /home/$USER/.bashrc
echo "export GOPATH=\$HOME/go" >> /home/$USER/.bashrc
echo "export GOROOT=/usr/local/go" >> /home/$USER/.bashrc
echo "export PATH=\$PATH:/usr/local/go/bin:\$HOME/go/bin" >> /home/$USER/.bashrc
echo >> /home/$USER/.bashrc
mkdir -p /home/$USER/go
chown -R $USER:$USER /home/$USER/go
