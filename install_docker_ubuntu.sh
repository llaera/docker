#!/bin/bash
#AUTHOR=Loris Laera
#Automatic traefik docker installer, docker & docker-compose needed.
#https://github.com/llaera/docker
echo "Running sudo apt-get -qq update / Looking for system updates..."
sudo apt-get -qq update
echo "Installing ca-certificates curl gnupg lsb-release ..."
sudo apt-get install ca-certificates curl gnupg lsb-release -y
echo "Adding Docker repository..."
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmor -o /usr/share/keyrings/docker-archive-keyring.gpg
echo \
  "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/docker-archive-keyring.gpg] https://download.docker.com/linux/ubuntu \
  $(lsb_release -cs) stable" | sudo tee /etc/apt/sources.list.d/docker.list > /dev/null
echo "Running sudo apt-get -qq update / Looking for system updates & docker..."
sudo apt-get -qq update
echo "Installing docker-ce docker-ce-cli containerd.io docker-compose-plugin ..."
sudo apt-get install docker-ce docker-ce-cli containerd.io docker-compose-plugin -y
echo "Docker post installation steps..."
sudo groupadd docker
sudo usermod -aG docker $USER
sudo systemctl enable docker.service
sudo systemctl enable containerd.service
echo "Installing docker compose..."
DOCKER_CONFIG=${DOCKER_CONFIG:-$HOME/.docker}
mkdir -p $DOCKER_CONFIG/cli-plugins
curl -SL https://github.com/docker/compose/releases/download/v2.4.1/docker-compose-linux-x86_64 -o $DOCKER_CONFIG/cli-plugins/docker-compose
chmod +x $DOCKER_CONFIG/cli-plugins/docker-compose
docker compose version
echo "Installing docker-compose..."
sudo apt-get install docker-compose -y
docker-compose --version
echo "You need to reload your shell by signing out and in again."
echo "Made by Loris Laera - github.com/llaera/docker"
exit