#!/bin/bash

# Install web server and php
sudo apt update
sudo apt install -y nginx php-fpm

# Configure firewall (allow SSH, HTTP, HTTPS)
sudo ufw allow 22
sudo ufw allow 80 #for site-a
sudo ufw allow 443 #for site-a
sudo ufw allow 8080 #for site-b
sudo ufw enable

# Add users
# user 1
# user 2

#site-a
sudo mkdir -p /var/www/site-a/html
sudo chown -R $USER:$USER /var/www/site-a/html
sudo chmod -R 755 /var/www/site-a

#site-b
sudo mkdir -p /var/www/site-b/html
sudo chown -R $USER:$USER /var/www/site-b/html
sudo chmod -R 755 /var/www/site-b

sudo cat index.php > /var/www/site-b/html/index.php # дописать содержимое

sudo cat default > /etc/nginx/sites-available/default # дописать содержимое

# Add SSL certificate (Let's Encrypt)
sudo snap install core; sudo snap refresh core
sudo snap install --classic certbot
sudo ln -s /snap/bin/certbot /usr/bin/certbot

sudo certbot --nginx -d learndevopsandrei.ddns.net # get cert

sudo cat addssl >> /etc/nginx/sites-available/default # add nginx config for ssl

# Manage logs Nginx