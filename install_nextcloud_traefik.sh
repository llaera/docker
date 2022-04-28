#!/bin/bash
#AUTHOR=Loris Laera
#Automatic Nextcloud docker installer, docker, docker-compose & traefik needed.
#https://github.com/llaera/docker
echo "Creating directory in /opt/containers/nextcloud ..."
sudo mkdir -p /opt/containers/nextcloud/{database,app,data}
sudo mkdir -p /opt/containers/nextcloud/.pwd
echo "Downloading docker-compose.yml from github.com/llaera/docker/main/nextcloud/docker-compose.yml ..."
sudo wget -q -L -O /opt/containers/nextcloud/docker-compose.yml https://raw.githubusercontent.com/llaera/docker/main/nextcloud/docker-compose.yml
sudo wget -q -L -O /opt/containers/nextcloud/nextcloud_additional-config.txt https://raw.githubusercontent.com/llaera/docker/main/nextcloud/nextcloud_additional-config.txt
echo
echo "Database Credentials Setup:"
sleep 3
echo "Please type in your root database password in the editor!"
sleep 4
sudo nano /opt/containers/nextcloud/.pwd/db_root_password.txt
echo "Please type in your username in the editor!"
sleep 4
sudo nano /opt/containers/nextcloud/.pwd/db_user.txt
echo "Please type in your user password in the editor!"
sleep 4
sudo nano /opt/containers/nextcloud/.pwd/db_password.txt
echo "Please type in your database name in the editor!"
sleep 4
sudo nano /opt/containers/nextcloud/.pwd/db_database.txt
echo "Change redis password in docker-compose.yml. Password can be extremely long, you don't need to remember it!"
sudo nano /opt/containers/nextcloud/docker-compose.yml
while true; do
    read -p "Do you wish to start nextcloud? Type Y for Yes an N for No! " yn
    case $yn in
        [Yy]* ) docker-compose -f /opt/containers/nextcloud/docker-compose.yml up -d; break;;
        [Nn]* ) exit;;
        * ) echo "Please answer y or n. You can start it later with docker-compose -f /opt/containers/nextcloud/docker-compose.yml up -d";;
    esac
done
docker inspect traefik
sudo cat /opt/containers/nextcloud/nextcloud_additional-config.txt
echo "Made by Loris Laera - github.com/llaera/docker"