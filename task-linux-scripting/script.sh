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

# Install web server
sudo apt update
sudo apt install -y nginx${vnginx} php-fpm${vphpfpm} openssl${vopenssl}

# Configure firewall (allow SSH, HTTP, HTTPS)
sudo ufw allow 22
sudo ufw allow 80
sudo ufw allow 443
sudo ufw enable

# Create chroot environment
jailpath=/home/jail
sudo mkdir -p $jailpath/usr/bin
# Copy utils to chroot
sudo cp /usr/bin/{bash,cat,ls,touch,mkdir,vi} $jailpath/usr/bin/

# Copy utils library to chroot
sudo cp -r lib $jailpath/usr/
sudo ln -rs $jailpath/usr/lib $jailpath/lib
sudo ln -rs $jailpath/usr/lib $jailpath/lib64

# Provide basic configuration for chroot
sudo mkdir -p $jailpath/etc $jailpath/usr/share
sudo cp /etc/{group,passwd,shadow,hosts} $jailpath/etc
sudo cp -r /usr/share/terminfo $jailpath/usr/share/

# Provide the special files in directories in /dev for chroot
sudo mkdir $jailpath/dev
sudo mknod $jailpath/dev/null c 1 3
sudo mknod $jailpath/dev/zero c 1 5
sudo mknod $jailpath/dev/tty c 5 0
sudo mknod $jailpath/dev/random c 1 8
sudo mknod $jailpath/dev/urandom c 1 9
sudo chmod 0666 $jailpath/dev/{null,tty,zero}
sudo chown root:tty $jailpath/dev/tty

# Create users and add ssk keys
sudo mkdir -p $jailpath/home

# Create user-a and configure ssh
sudo useradd --base-dir $jailpath/home --create-home --shell /usr/bin/bash user-a
sudo mkdir -p $jailpath/home/user-a/.ssh
sudo cp user-a-authorized_keys $jailpath/home/user-a/.ssh/authorized_keys
sudo chmod 600 $jailpath/home/user-a/.ssh/authorized_keys
sudo chown -R user-a:user-a $jailpath/home/user-a/.ssh/

# Create user-b and configure ssh
sudo useradd --base-dir $jailpath/home --create-home --shell /usr/bin/bash user-b
sudo mkdir -p $jailpath/home/user-b/.ssh
sudo cp user-b-authorized_keys $jailpath/home/user-b/.ssh/authorized_keys
sudo chmod 600 $jailpath/home/user-b/.ssh/authorized_keys
sudo chown -R user-b:user-b $jailpath/home/user-b/.ssh/

# Configure SSH to chroot
printf "Match User user-a,user-b\n\tChrootDirectory $jailpath\n\tPasswordAuthentication no" | sudo tee -a /etc/ssh/sshd_config > /dev/null
sudo systemctl reload sshd.service

#site-a
sudo mkdir -p $jailpath/home/user-a/site-a/html
sudo cp index.php $jailpath/home/user-a/site-a/html/index.php # create server info page for site-a
sudo chown -R user-a:user-a $jailpath/home/user-a/site-a/html

#site-b
sudo mkdir -p $jailpath/home/user-b/site-b/html
sudo cp /var/www/html/index.nginx-debian.html $jailpath/home/user-b/site-b/html/index.html # default server info page for site-b
sudo chown -R user-b:user-b $jailpath/home/user-b/site-b/html

sudo cp nginxconf /etc/nginx/sites-available/default # setting nginx config

# Add SSL certificate (self-sign ssl)
sudo openssl req -x509 -nodes -days 365 -newkey rsa:2048 -keyout /etc/ssl/private/nginx-selfsigned.key -out /etc/ssl/certs/nginx-selfsigned.crt

# Manage logs
sudo cp logrotateconf /etc/logrotate.d/nginx

sudo systemctl restart nginx