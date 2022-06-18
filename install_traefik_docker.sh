#!/bin/bash
#AUTHOR=Loris Laera
#Automatic traefik docker installer, docker & docker compose needed.
#https://github.com/llaera/docker
echo "Running sudo apt-get -qq update / Looking for system updates..."
sudo apt-get -qq update
echo
echo "Running sudo apt-get -qq upgrade -y / Installing system updates..."
sudo apt-get -qq upgrade -y
echo
echo "Installing apache2-utils & wget / Needed for user,password hash and downloading files."
sudo apt-get -qq install apache2-utils wget -y
echo
echo "Creating directories in /opt/containers/traefik & /opt/containers/traefik/data / This stores all your configuration files as SSL keys."
sudo mkdir -p /opt/containers/traefik
sudo mkdir -p /opt/containers/traefik/data
echo
echo "Downloading configuration templates from github.com/llaera/docker/main/traefik/ ..."
sudo wget -q -L -O /opt/containers/traefik/data/traefik.yml https://raw.githubusercontent.com/llaera/docker/main/traefik/traefik.yml
sudo wget -q -L -O /opt/containers/traefik/docker-compose.yml https://raw.githubusercontent.com/llaera/docker/main/traefik/docker-compose.yml
sudo wget -q -L -O /opt/containers/traefik/data/dynamic_conf.yml https://raw.githubusercontent.com/llaera/docker/main/traefik/dynamic_conf.yml
echo
echo "Creating file for SSL keys storage & change of permissions to 600."
sudo touch /opt/containers/traefik/data/acme.json
sudo chmod 600 /opt/containers/traefik/data/acme.json
echo
echo "Creating docker network proxy:"
docker network create proxy
echo
echo
echo "User Configuration and Setup:"
echo "Select your traefik username:"
read user
echo "Type in a password for your traefik account:" 
read password
echo
echo "Copy the next line:"
sleep 3
echo $(htpasswd -nb $user $password) | sed -e s/\\$/\\$\\$/g
echo
sleep 3
echo "A text editor will soon open soon, you can only use the keyboard to navigate, replace USER:PASSWORD in line 24 of your docker-compose.yml with what you copied earlier, use a simple paste."
sleep 3
echo "You will also need to change the url in line 23 & 28, from traefik.example.com to traefik.yourdomain.com, using your domain or course."
sleep 15
echo
echo "The editor will open in 3 seconds."
sleep 3
sudo nano /opt/containers/traefik/docker-compose.yml
echo
echo "Don't forget to replace example@example.com with your E-Mail in traefik.yml."
sleep 10
echo "The editor will open in 2 seconds."
sleep 2
sudo nano /opt/containers/traefik/data/traefik.yml
echo
echo
while true; do
    read -p "Do you wish to initialise traefik? Type Y for Yes an N for No! " yn
    case $yn in
        [Yy]* ) docker compose -f /opt/containers/traefik/docker-compose.yml up -d; break;;
        [Nn]* ) exit;;
        * ) echo "Please answer y or n. You can start it later with docker compose -f /opt/containers/traefik/docker-compose.yml up -d";;
    esac
done
echo "github.com/llaera/docker"