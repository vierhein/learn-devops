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
sudo useradd -p $(perl -e 'print crypt($ARGV[0], "password")' '123456') user-a
sudo useradd -p $(perl -e 'print crypt($ARGV[0], "password")' '123456') user-b

#site-a
sudo mkdir -p /var/www/site-a/html
sudo chown -R $USER:$USER /var/www/site-a/html
sudo chmod -R 755 /var/www/site-a

#site-b
sudo mkdir -p /var/www/site-b/html
sudo chown -R user-b:user-b /var/www/site-b/html
sudo chmod -R 755 /var/www/site-b

sudo cat index.php > /var/www/site-a/html/index.php # create server info page for site-a
sudo chown $USER:$USER /etc/nginx/sites-available/default
sudo cat default > /etc/nginx/sites-available/default # setting nginx config

# Add SSL certificate (Certbot)
sudo snap install core; sudo snap refresh core
sudo snap install --classic certbot
sudo ln -s /snap/bin/certbot /usr/bin/certbot

sudo certbot --nginx -d learndevopsandrei.ddns.net # get cert
sudo cat addssl >> /etc/nginx/sites-available/default # add nginx config for ssl

# Manage logs
sudo chown $USER:$USER /etc/logrotate.d/nginx
sudo cat logrotateconf > /etc/logrotate.d/nginx

# Get permission to user-a for site-a
sudo chown -R user-a:user-a /var/www/site-a/html
sudo chown root:root /etc/nginx/sites-available/default
sudo chown root:root /etc/logrotate.d/nginx

sudo systemctl restart nginx