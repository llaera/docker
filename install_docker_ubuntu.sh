#!/bin/bash
#Automatic Docker on Ubuntu installer.
#https://github.com/llaera/docker
BIGreen='\033[1;92m'
On_IPurple='\033[0;105m'
NC='\033[0m'
echo -e "${BIGreen}Running sudo apt-get -qq update / Updating repository...${NC}"
sudo apt-get -qq update
echo -e "${BIGreen}Installing ca-certificates curl gnupg lsb-release...${NC}"
sudo apt-get -qq install ca-certificates curl gnupg lsb-release -y
echo -e "${BIGreen}Adding Docker repository...${NC}"
sudo mkdir -p /etc/apt/keyrings
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmor -o /etc/apt/keyrings/docker.gpg
echo \
  "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.gpg] https://download.docker.com/linux/ubuntu \
  $(lsb_release -cs) stable" | sudo tee /etc/apt/sources.list.d/docker.list > /dev/null
echo -e "${BIGreen}Runninng update... & Installing docker...${NC}"
sudo apt-get -qq update && sudo apt-get -qq install docker-ce docker-ce-cli containerd.io docker-compose-plugin -y
sudo groupadd docker
sudo usermod -aG docker $USER
newgrp docker
docker compose version
echo -e "github.com/llaera/docker"
exit