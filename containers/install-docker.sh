#!/bin/bash

. /etc/os-release

if [ "$NAME" != "Ubuntu" ]; then
    echo "This script is for Ubuntu."
    exit
fi

# update repo
sudo apt-get update

# install curl
sudo apt-get install -y curl

# add GPG key
sudo apt-get install -y ca-certificates gnupg
sudo install -m 0755 -d /etc/apt/keyrings
sudo rm -f /etc/apt/keyrings/docker.gpg
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmor -o /etc/apt/keyrings/docker.gpg
sudo chmod a+r /etc/apt/keyrings/docker.gpg

# add Docker repository
echo \
  "deb [arch="$(dpkg --print-architecture)" signed-by=/etc/apt/keyrings/docker.gpg] https://download.docker.com/linux/ubuntu \
  "$(. /etc/os-release && echo "$VERSION_CODENAME")" stable" | \
  sudo tee /etc/apt/sources.list.d/docker.list > /dev/null

# update the Docker repo
sudo apt-get update

# make sure we install Docker from the Docker repo
sudo apt-cache policy docker-ce

# install Docker (latest stable) and the compose/buildx plugins
sudo apt-get install -y docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin

# configure daemon.json
sudo mkdir -p /etc/docker
cat <<EOF | sudo tee /etc/docker/daemon.json
{
    "exec-opts": ["native.cgroupdriver=systemd"],
    "log-driver": "json-file",
    "log-opts": {
        "max-size": "100m"
    },
    "storage-driver": "overlay2"
}
EOF

# start Docker
sudo systemctl restart docker
sleep 1

# add user to docker group (effective after re-login)
sudo usermod -aG docker $USER

echo ">> Note <<"
echo "Log out and back in (or run 'newgrp docker') for the docker group to take effect."
echo "Use 'docker compose ...' (compose v2 plugin) instead of the legacy 'docker-compose' binary."
