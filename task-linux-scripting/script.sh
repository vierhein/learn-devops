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
sudo chown -R user-a:user-a /var/www/site-a/html
sudo chmod -R 755 /var/www/site-a

#site-b
sudo mkdir -p /var/www/site-b/html
sudo chown -R user-b:user-b /var/www/site-b/html
sudo chmod -R 755 /var/www/site-b

sudo cat index.php | sudo tee /var/www/site-a/html/index.php # create server info page for site-a
sudo cat default | sudo tee /etc/nginx/sites-available/default # setting nginx config

# Add SSL certificate (Certbot)


#sudo certbot --nginx -d learndevopsandrei.ddns.net # get cert
sudo cat addssl | sudo tee -a /etc/nginx/sites-available/default # add nginx config for ssl

# Manage logs
sudo cat logrotateconf | sudo tee /etc/logrotate.d/nginx

sudo systemctl restart nginx