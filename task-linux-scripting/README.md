# devops
1. Set up server access using SSH with a key. <br>

Run: ssh-keygen -t ed25519 <br>
Follow the prompts to generate a new SSH key pair <br>
Run: ssh-copy-id username@ip
Connect to server via ssh <br>

2. Create user for run script.sh and set permissions to execute script<br>

sudo useradd -p $(perl -e 'print crypt($ARGV[0], "password")' '123456') user-run <br>
cp sudoers-user /etc/sudoers.d/

3. Test local
127.0.0.1   site-a.local <br>
127.0.0.1   www.site-a.local <br>
127.0.0.1   site-b.local <br>
127.0.0.1   www.site-b.local <br>