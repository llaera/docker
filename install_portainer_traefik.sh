#!/bin/bash
#AUTHOR=Loris Laera
#Automatic portainer docker installer, docker, docker-compose & traefik needed.
#https://github.com/llaera/docker
BIGreen='\033[1;92m'
On_IPurple='\033[0;105m'
NC='\033[0m'
echo -e "${BIGreen}Creating directory in /opt/containers/portainer${NC}"
sudo mkdir -p /opt/containers/portainer
echo -e "${BIGreen}Downloading docker-compose.yml from github.com/llaera/docker/main/portainer/docker-compose.yml${NC}"
sudo wget -q -L -O /opt/containers/portainer/docker-compose.yml https://raw.githubusercontent.com/llaera/docker/main/portainer/docker-compose.yml
echo -e "${BIGreen}${On_IPurple}Type in your portainer URL! Usually if your domain is example.com you would use portainer.example.com, but it is up to you. Do not forget to add the subdomain in your DNS records or enable wildcard DNS record.${NC}"
read url
sudo sed -i "s|portainer.example.com|$url|g" /opt/containers/portainer/docker-compose.yml
while true; do
    read -p "Do you wish to start portainer? Type Y for Yes an N for No! " yn
    case $yn in
        [Yy]* ) docker-compose -f /opt/containers/portainer/docker-compose.yml up -d; break;;
        [Nn]* ) exit;;
        * ) echo -e "${BIGreen}Please answer y or n. You can start it later with docker-compose -f /opt/containers/portainer/docker-compose.yml up -d"${NC};;
    esac
done
echo -e "${BIGreen}github.com/llaera/docker${NC}"