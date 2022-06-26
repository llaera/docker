#!/bin/bash
#AUTHOR=Loris Laera
#Automatic traefik docker installer, docker & docker compose needed.
#https://github.com/llaera/docker
BIGreen='\033[1;92m'
On_IPurple='\033[0;105m'
NC='\033[0m'
echo -e "${BIGreen}Running sudo apt-get -qq update / Updating repository...${NC}"
sudo apt-get -qq update
echo
echo -e "${BIGreen}Installing apache2-utils & wget / Needed for user,password hash and downloading files.${NC}"
sudo apt-get -qq install apache2-utils wget -y
echo
echo -e "${BIGreen}Creating directories in /opt/containers/traefik & /opt/containers/traefik/data / This stores all your configuration files as SSL keys.${NC}"
sudo mkdir -p /opt/containers/traefik
sudo mkdir -p /opt/containers/traefik/data
echo
echo -e "${BIGreen}Downloading configuration templates from github.com/llaera/docker/main/traefik/${NC}"
sudo wget -q -L -O /opt/containers/traefik/data/traefik.yml https://raw.githubusercontent.com/llaera/docker/main/traefik/traefik.yml
sudo wget -q -L -O /opt/containers/traefik/docker-compose.yml https://raw.githubusercontent.com/llaera/docker/main/traefik/docker-compose.yml
sudo wget -q -L -O /opt/containers/traefik/data/dynamic_conf.yml https://raw.githubusercontent.com/llaera/docker/main/traefik/dynamic_conf.yml
echo
echo -e "${BIGreen}Creating file for SSL keys storage & change of permissions to 600.${NC}"
sudo touch /opt/containers/traefik/data/acme.json
sudo chmod 600 /opt/containers/traefik/data/acme.json
echo
echo -e "${BIGreen}Creating docker network proxy:${NC}"
docker network create proxy
echo
echo -e "${BIGreen}${On_IPurple}Select your traefik username:${NC}"
read user
echo -e "${BIGreen}${On_IPurple}Type in a password for your traefik account:${NC}" 
read password
sudo sed -i "s|USER:PASSWORD|$(htpasswd -nb $user $password)|g" /opt/containers/traefik/docker-compose.yml
echo -e "${BIGreen}${On_IPurple}Type in your traefik URL! Usually if your domain is example.com you would use traefik.example.com, but it is up to you. Do not forget to add the subdomain in your DNS records or enable wildcard DNS record.${NC}"
read url
sudo sed -i "s|traefik.YOURDOMAIN.COM|$url|g" /opt/containers/traefik/docker-compose.yml
echo -e "${BIGreen}${On_IPurple}Please type in a valid E-Mail for Let's Encrypt, this information is mandatory:${NC}"
read email
echo -e "${BIGreen}${On_IPurple}Don't forget to replace example@example.com with your E-Mail in traefik.yml.${NC}"
sudo sed -i "s|example@mail.com|$email|g" /opt/containers/traefik/data/traefik.yml
echo
while true; do
    read -p "Do you wish to initialise traefik? Type Y for Yes an N for No! " yn
    case $yn in
        [Yy]* ) docker compose -f /opt/containers/traefik/docker-compose.yml up -d; break;;
        [Nn]* ) exit;;
        * ) echo -e "${BIGreen}Please answer y or n. You can start it later with docker compose -f /opt/containers/traefik/docker-compose.yml up -d${NC}";;
    esac
done
echo -e "${BIGreen}github.com/llaera/docker${NC}"