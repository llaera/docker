#!/bin/bash
#AUTHOR=Loris Laera
#Automatic Collabora docker installer, docker, docker-compose & traefik needed.
#https://github.com/llaera/docker
sudo mkdir -p /opt/containers/collabora/
echo "Downloading docker-compose.yml from github.com/llaera/docker/main/collabora/docker-compose.yml ..."
sudo wget -q -L -O /opt/containers/collabora/docker-compose.yml https://raw.githubusercontent.com/llaera/docker/main/collabora/docker-compose.yml
echo "Change Username, Password & Links in docker-compose.yml, the editor will open soon."
sleep 7
sudo nano /opt/containers/collabora/docker-compose.yml
while true; do
    read -p "Do you wish to start collabora? Type Y for Yes an N for No! " yn
    case $yn in
        [Yy]* ) docker-compose -f /opt/containers/collabora/docker-compose.yml up -d; break;;
        [Nn]* ) exit;;
        * ) echo "Please answer y or n. You can start it later with docker-compose -f /opt/containers/collabora/docker-compose.yml up -d";;
    esac
done
echo "Made by Loris Laera - github.com/llaera/docker"