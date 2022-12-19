#!/bin/bash

# update repo
sudo apt-get update

# install java
sudo apt-get -y install openjdk-11-jdk

# add JAVA_HOME
echo >> /home/vagrant/.bashrc
echo "export JAVA_HOME=\$(readlink -f /usr/bin/java | sed 's:bin/java::')" >> /home/vagrant/.bashrc
