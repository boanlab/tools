#!/bin/bash

. /etc/os-release

if [ "$NAME" != "Ubuntu" ]; then
    echo "This script is for Ubuntu."
    exit
fi

if [ ! -x "$(command -v java)" ]; then
    # update repo
    sudo apt-get update

    # install java
    sudo apt-get -y install openjdk-11-jdk

    # add JAVA_HOME
    echo >> /home/$USER/.bashrc
    echo "export JAVA_HOME=\$(readlink -f /usr/bin/java | sed 's:bin/java::')" >> /home/$USER/.bashrc
else
    echo "Found Java, skipping the installation of Java."
fi
