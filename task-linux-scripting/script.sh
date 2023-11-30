#!/bin/bash

# Set versions packages, default - latest
while getopts ":n:p:s:" opt; do
  case $opt in
    n)
      vnginx="=$OPTARG"
      ;;
    p)
      vphpfpm="=$OPTARG"
      ;;
    s)
      vopenssl="=$OPTARG"
      ;;
    \?)
      echo "Invalid option: -$OPTARG" >&2
      exit 1
      ;;
    :)
      echo "Option -$OPTARG requires an argument." >&2
      exit 1
      ;;
  esac
done

# Install web server and php
sudo apt update
sudo apt install nginx${vnginx} php-fpm${vphpfpm} openssl${vopenssl}

# Configure firewall (allow SSH, HTTP, HTTPS)
sudo ufw allow 22
sudo ufw allow 80
sudo ufw allow 443
sudo ufw enable

# Add users for sites administration
sudo useradd -m user-a
sudo useradd -m user-b

#site-a
sudo mkdir -p /var/www/site-a/html
sudo chown -R user-a:user-a /var/www/site-a/html
sudo chmod -R 755 /var/www/site-a

#site-b
sudo mkdir -p /var/www/site-b/html
sudo chown -R user-b:user-b /var/www/site-b/html
sudo chmod -R 755 /var/www/site-b

sudo cat index.php | sudo tee /var/www/site-a/html/index.php > /dev/null # create server info page for site-a
sudo cp /var/www/html/index.nginx-debian.html /var/www/site-b/html/index.html # default server info page for site-b
sudo cat nginxconf | sudo tee /etc/nginx/sites-available/default > /dev/null # setting nginx config

# Add SSL certificate (self-sign ssl)
sudo openssl req -x509 -nodes -days 365 -newkey rsa:2048 -keyout /etc/ssl/private/nginx-selfsigned.key -out /etc/ssl/certs/nginx-selfsigned.crt

# Manage logs
sudo cat logrotateconf | sudo tee /etc/logrotate.d/nginx > /dev/null

sudo systemctl restart nginx