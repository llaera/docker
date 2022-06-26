#!/bin/bash
#AUTHOR=Loris Laera
#Automatic Nextcloud docker installer, docker, docker-compose & traefik needed.
#Passwords are generated automatically.
#https://github.com/llaera/docker
echo -e "${BIGreen}Running sudo apt-get -qq update / Updating repository...${NC}"
sudo apt-get -qq update
echo "Creating directory in /opt/containers/nextcloud ..."
sudo mkdir -p /opt/containers/nextcloud/{database,app,data}
sudo mkdir -p /opt/containers/nextcloud/.pwd
echo "Installing wget / Needed for downloading files."
sudo apt-get -qq install wget openssl -y
echo "Downloading docker-compose.yml from github.com/llaera/docker/main/nextcloud/docker-compose.yml ..."
sudo wget -q -L -O /opt/containers/nextcloud/docker-compose.yml https://raw.githubusercontent.com/llaera/docker/main/nextcloud/docker-compose.yml
sudo wget -q -L -O /opt/containers/nextcloud/nextcloud_additional-config.txt https://raw.githubusercontent.com/llaera/docker/main/nextcloud/nextcloud_additional-config.txt
echo "Generating passwords..."
sudo touch /opt/containers/nextcloud/.pwd/db_root_password.txt
sudo touch /opt/containers/nextcloud/.pwd/db_password.txt
sudo echo $(openssl rand -base64 128) > /opt/containers/nextcloud/.pwd/db_root_password.txt
sudo echo $(openssl rand -base64 128) > /opt/containers/nextcloud/.pwd/db_password.txt
sudo sed -i "s|RedisPASS|$(openssl rand -base64 64)|g" /opt/containers/nextcloud/docker-compose.yml
sudo sed -i "s|COLLPASSWORD|$(openssl rand -base64 16)|g" /opt/containers/nextcloud/docker-compose.yml
echo "Name your database:"
read DBNAME
sudo sed -i "s|DBNAME|$DBNAME|g" /opt/containers/nextcloud/docker-compose.yml
echo "Create a user in your database, type in a username:"
read USERNAME
sudo sed -i "s|USERNAME|$USERNAME|g" /opt/containers/nextcloud/docker-compose.yml
echo -e "${BIGreen}${On_IPurple}Type in your Nextcloud URL! Usually if your domain is example.com you would use nextcloud.example.com, but it is up to you. Do not forget to add the subdomain in your DNS records or enable wildcard DNS record.${NC}"
read url
sudo sed -i "s|cloud.YOURDOMAIN.COM|$url|g" /opt/containers/traefik/docker-compose.yml
echo -e "${BIGreen}${On_IPurple}Type in your Collabora URL! I advise to use collabora.yourdomain.com${NC}"
read collurl
sudo sed -i "s|collabora.YOURDOMAIN.COM|$collurl|g" /opt/containers/traefik/docker-compose.yml
echo "Create a Collabora username:"
read COLLUSERNAME
sudo sed -i "s|COLLUSERNAME|$COLLUSERNAME|g" /opt/containers/nextcloud/docker-compose.yml
while true; do
    read -p "Do you wish to start nextcloud? Type Y for Yes an N for No! " yn
    case $yn in
        [Yy]* ) docker compose -f /opt/containers/nextcloud/docker-compose.yml up -d; break;;
        [Nn]* ) exit;;
        * ) echo "Please answer y or n. You can start it later with docker compose -f /opt/containers/nextcloud/docker-compose.yml up -d";;
    esac
done
docker inspect traefik
sudo cat /opt/containers/nextcloud/nextcloud_additional-config.txt
echo "github.com/llaera/docker"