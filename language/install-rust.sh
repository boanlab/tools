#!/bin/bash

. /etc/os-release

if [ "$NAME" != "Ubuntu" ]; then
    echo "This script is for Ubuntu."
    exit
fi

# install rust
curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh
