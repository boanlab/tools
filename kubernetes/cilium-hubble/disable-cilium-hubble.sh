#!/bin/bash

if [ -f /usr/local/bin/cilium ]; then
    # enable hubble in cilium
    /usr/local/bin/cilium hubble disable

    # wait for a while
    sleep 5

    # validate that hubble is enabled and running
    /usr/local/bin/cilium status
fi
