#!/bin/bash
#Automatic Docker on Ubuntu installer.
#https://github.com/llaera/docker
echo "Runninng update..."
sudo apt-get -qq update
echo "Installing ca-certificates curl gnupg lsb-release..."
sudo apt-get -qq install ca-certificates curl gnupg lsb-release -y
echo "Adding Docker repository..."
sudo mkdir -p /etc/apt/keyrings
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmor -o /etc/apt/keyrings/docker.gpg
echo \
  "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.gpg] https://download.docker.com/linux/ubuntu \
  $(lsb_release -cs) stable" | sudo tee /etc/apt/sources.list.d/docker.list > /dev/null
echo "Runninng update... & Installing docker..."
sudo apt-get -qq update && sudo apt-get -qq install docker-ce docker-ce-cli containerd.io docker-compose-plugin -y
sudo groupadd docker
sudo usermod -aG docker $USER
echo "Verifiy install with 'docker compose version'"
newgrp docker
exit