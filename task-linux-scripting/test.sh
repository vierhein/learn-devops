# Create chroot environment
mkdir -p /chroot-jail-root/usr/bin
# Copy utils
cp /usr/bin/{bash,cat,ls,vi} /chroot-jail-root/usr/bin/

# Copy library
sudo cp -r lib /chroot-jail-root/usr/
sudo ln -rs /chroot-jail-root/usr/lib /chroot-jail-root/lib
sudo ln -rs /chroot-jail-root/usr/lib /chroot-jail-root/lib64

# Provide basic configuration
sudo mkdir -p /chroot-jail-root/etc /chroot-jail-root/usr/share
sudo cp /etc/{group,passwd,shadow,hosts} /etc
sudo cp -r /usr/share/terminfo /chroot-jail-root/usr/share/

# Provide the special files in directories in /dev
sudo mkdir /chroot-jail-root/dev
sudo mknod /chroot-jail-root/dev/null c 1 3
sudo mknod /chroot-jail-root/dev/zero c 1 5
sudo mknod /chroot-jail-root/dev/tty c 5 0
sudo mknod /chroot-jail-root/dev/random c 1 8
sudo mknod /chroot-jail-root/dev/urandom c 1 9
sudo chmod 0666 /chroot-jail-root/dev/{null,tty,zero}
sudo chown root:tty /chroot-jail-root/dev/tty

# Create users and add ssk keys
sudo mkdir -p /chroot-jail-root/home

# user a
sudo useradd --base-dir /chroot-jail-root/home --create-home --shell /usr/bin/bash user-d
sudo mkdir -p /chroot-jail-root/home/user-d/.ssh
sudo cp user-a-authorized_keys /chroot-jail-root/home/user-d/.ssh/authorized_keys
sudo chmod 600 /chroot-jail-root/home/user-d/.ssh/authorized_keys
sudo chown -R user-d:user-d /chroot-jail-root/home/user-d/.ssh/

# user b
sudo useradd --base-dir /chroot-jail-root/home --create-home --shell /usr/bin/bash user-e
sudo mkdir -p /chroot-jail-root/home/user-e/.ssh
sudo cp user-b-authorized_keys /chroot-jail-root/home/user-e/.ssh/authorized_keys
sudo chmod 600 /chroot-jail-root/home/user-e/.ssh/authorized_keys
sudo chown -R user-e:user-e /chroot-jail-root/home/user-e/.ssh/

# Configure SSH to chroot
printf "Match User user-d,user-e\n\tChrootDirectory /chroot-jail-root\n\tPasswordAuthentication no" | sudo tee -a /etc/ssh/sshd_config > /dev/null
sudo systemctl reload sshd.service



