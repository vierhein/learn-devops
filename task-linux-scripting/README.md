# devops
1. Set up server access using SSH with a key. <br>

Run: ssh-keygen -t ed25519 <br>
Follow the prompts to generate a new SSH key pair <br>
Connect to server via password <br>
Copy the public key to the server to ~/.ssh/authorized_keys <br>
Connect to server via ssh <br>
Run: sudo chmod +x /path/to/script.sh <br>

2. Create user for run script.sh <br>

sudo useradd -p $(perl -e 'print crypt($ARGV[0], "password")' '123456') user-run <br>
sudo chown user-run:user-run /path/to/script.sh <br>

3. Get domain name learndevopsandrei.ddns.net
