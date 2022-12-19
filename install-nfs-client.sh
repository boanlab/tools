#!/bin/bash

# update repo
sudo apt-get update

# install nfs client
apt-get -y install nfs-common cifs-utils
