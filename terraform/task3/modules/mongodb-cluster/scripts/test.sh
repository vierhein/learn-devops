#!/bin/bash
echo "${dns_name}" | sudo tee /test.txt
MONGO_USER="admin"
MONGO_PASSWORD="password"

sudo hostnamectl set-hostname $dns_name

cat <<EOF | sudo tee /etc/yum.repos.d/mongodb-org-7.0.repo
[mongodb-org-7.0]
name=MongoDB Repository
baseurl=https://repo.mongodb.org/yum/amazon/2023/mongodb-org/7.0/x86_64/
gpgcheck=1
enabled=1
gpgkey=https://www.mongodb.org/static/pgp/server-7.0.asc
EOF

sudo yum install -y mongodb-mongosh-shared-openssl3
sudo yum install -y mongodb-org-7.0.1

# Append the line to /etc/yum.conf
echo "exclude=mongodb-org,mongodb-org-database,mongodb-org-server,mongodb-mongosh,mongodb-org-mongos,mongodb-org-tools" | sudo tee -a /etc/yum.conf

# Start MongoDB
sudo systemctl daemon-reload
sudo systemctl start mongod
sudo systemctl enable mongod
chkconfig mongod on

sudo mongosh <<EOF
use admin
db.createUser(
  {
    user: "$MONGO_USER",
    pwd: "$MONGO_PASSWORD", 
    roles: [ { role: "root", db: "admin" }]
  }
)
EOF