# Manage restart php in chroot
jailpath=/home/jail
sudo touch /home/reload-php
sudo cp /home/reload-php $jailpath/home/user-a/
sudo mount --bind /home/reload-php $jailpath/home/user-a/reload-php 
sudo chown user-a:user-a /home/reload-php
sudo cp daemon.sh /home/
sudo /home/daemon.sh &