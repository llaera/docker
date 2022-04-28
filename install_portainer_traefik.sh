#!/bin/bash
#AUTHOR=Loris Laera
#Automatic portainer docker installer, docker, docker-compose & traefik needed.
#https://github.com/llaera/docker
echo "Creating directory in /opt/containers/portainer"
sudo mkdir -p /opt/containers/portainer
echo "Downloading docker-compose.yml from github.com/llaera/docker/main/portainer/docker-compose.yml ..."
sudo wget -q -L -O /opt/containers/portainer/docker-compose.yml https://raw.githubusercontent.com/llaera/docker/main/portainer/docker-compose.yml
echo "Opening /opt/containers/portainer/docker-compose.yml in editor, adapt your url please, you need to replace example.com"
sleep 9
sudo nano /opt/containers/portainer/docker-compose.yml
while true; do
    read -p "Do you wish to start portainer? Type Y for Yes an N for No! " yn
    case $yn in
        [Yy]* ) docker-compose -f /opt/containers/portainer/docker-compose.yml up -d; break;;
        [Nn]* ) exit;;
        * ) echo "Please answer y or n. You can start it later with docker-compose -f /opt/containers/portainer/docker-compose.yml up -d";;
    esac
done
echo "Made by Loris Laera - github.com/llaera/docker"