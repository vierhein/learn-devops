# devops
1. Set up server access using SSH with a key. <br>

Run: ssh-keygen -t ed25519 <br>
Follow the prompts to generate a new SSH key pair <br>
Run: ssh-copy-id username@ip <br>
Connect to server via ssh <br>

2. Clone project to server <br>

3. Create user for run script.sh and set permissions to execute script<br>

sudo useradd -p $(perl -e 'print crypt($ARGV[0], "password")' '123456') user-run <br>
sudo cp path-toproject/sudoers-user /etc/sudoers.d/

4. Add public ssh keys for sites admins

Edit user-a-authorized_keys file for user-a
Edit user-b-authorized_keys file for user-b

5. Change user and run script <br>
Run: su - user-run <br>
Run: ./path-to-projec/script.sh <br>

Additional <br>
You can set version of packages using keys: <br>
-n for nginx version <br>
-p for php-fpm version <br>
-s for openssl version <br>
Using script without keys will install latest version of packages <br>
Example: <br>
./script.sh -n 5.2 -p 8.1 -s 1.1.1f-1ubuntu2 <br>

6. Test local <br>
Add to /etc/hosts following lines: <br>

127.0.0.1   site-a.local <br>
127.0.0.1   www.site-a.local <br>
127.0.0.1   site-b.local <br>
127.0.0.1   www.site-b.local <br>

7. Site admins can use editor vi and cat,ls,touch,mkdir utils <br>
   user-a can reload php service wiht reload-php file in his home directory. For reload write 1 in php-reload <br>
   Example: <br>
   echo 1 > reload-php <br>

