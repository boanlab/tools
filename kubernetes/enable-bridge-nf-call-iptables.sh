#!/bin/bash

# enable br_netfilter
sudo modprobe br_netfilter
if [ $(cat /proc/sys/net/bridge/bridge-nf-call-iptables) == 0 ]; then
    sudo bash -c "echo '1' > /proc/sys/net/bridge/bridge-nf-call-iptables"
    sudo bash -c "echo 'net.bridge.bridge-nf-call-iptables=1' >> /etc/sysctl.conf"
fi
