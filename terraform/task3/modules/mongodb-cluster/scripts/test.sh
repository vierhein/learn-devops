#!/bin/bash
DOMAIN_NAME="${domain_name}"
NUM_HOSTS="${num_hosts}"
NUM_HOST_CURRENT="${num_host_current}"
DNS_NAME="mongo${num_host_current}.${domain_name}"
MONGO_USER="${mongo_user}"
MONGO_PASSWORD="${mongo_password}"

sudo hostnamectl set-hostname $DNS_NAME

cat <<EOF | sudo tee /etc/yum.repos.d/mongodb-org-7.0.repo
[mongodb-org-7.0]
name=MongoDB Repository
baseurl=https://repo.mongodb.org/yum/amazon/2023/mongodb-org/7.0/x86_64/
gpgcheck=1
enabled=1
gpgkey=https://www.mongodb.org/static/pgp/server-7.0.asc
EOF

sudo yum install -y mongodb-org-7.0.3 mongodb-org-database-7.0.3 mongodb-org-server-7.0.3 mongodb-mongosh-shared-openssl3 mongodb-org-mongos-7.0.3 mongodb-org-tools-7.0.3

# Append the line to /etc/yum.conf
echo "exclude=mongodb-org,mongodb-org-database,mongodb-org-server,mongodb-mongosh,mongodb-org-mongos,mongodb-org-tools" | sudo tee -a /etc/yum.conf

# Start MongoDB
sudo systemctl daemon-reload
sudo systemctl start mongod
sudo systemctl enable mongod
chkconfig mongod on

sleep 30 #wait mongosh access 

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

#Copy SSL certificates
sudo mkdir -p /etc/mongodb/ssl
sudo chmod 700 /etc/mongodb/ssl
sudo chown -R mongod:mongod /etc/mongodb
sudo cp /tmp/cert/mongoCA.crt /etc/mongodb/ssl
sudo cp /tmp/cert/mongo.pem /etc/mongodb/ssl

#disable Transparent Huge Pages and THP defragmentation on a Linux system
cat <<EOF | sudo tee -a /etc/rc.local
if test -f /sys/kernel/mm/transparent_hugepage/enabled; then
    echo never > /sys/kernel/mm/transparent_hugepage/enabled
fi
if test -f /sys/kernel/mm/transparent_hugepage/defrag; then
    echo never > /sys/kernel/mm/transparent_hugepage/defrag
fi
exit 0
EOF

sudo chmod +x /etc/rc.local

#set soft limit for the number of processes
echo "mongod soft nproc 64000" | sudo tee -a /etc/security/limits.conf
echo "vm.max_map_count=262144" | sudo tee -a /etc/sysctl.conf
sudo sysctl -p
sysctl vm.max_map_count

#Update mongod.conf
cat <<EOF | sudo tee /etc/mongod.conf
# mongod.conf

# for documentation of all options, see:
#   http://docs.mongodb.org/manual/reference/configuration-options/

# where to write logging data.
systemLog:
  destination: file
  logAppend: true
  path: /var/log/mongodb/mongod.log

# Where and how to store data.
storage:
  dbPath: /var/lib/mongo

# how the process runs
processManagement:
  timeZoneInfo: /usr/share/zoneinfo

# network interfaces
net:
  port: 27017
  bindIp: 127.0.0.1,$DNS_NAME # Enter 0.0.0.0,:: to bind to all IPv4 and IPv6 addresses or, alternatively, use the net.bindIpAll setting.
  unixDomainSocket:
     enabled: true
     pathPrefix: /var/run/mongodb
  ssl:
     mode: requireTLS
     PEMKeyFile: /etc/mongodb/ssl/mongo.pem
     CAFile: /etc/mongodb/ssl/mongoCA.crt
     clusterFile: /etc/mongodb/ssl/mongo.pem

security:
  authorization: enabled
  clusterAuthMode: x509

#operationProfiling:

replication:
  replSetName: agencyMeshAppMongodb

#sharding:

## Enterprise-Only Options

#auditLog:
EOF

sudo systemctl restart mongod

if [[ $NUM_HOST_CURRENT -eq 1 ]] && [ $NUM_HOSTS -gt 1 ]; then
    sleep 20
    #Generate settings
    ARRAY=()
    for ((i = 0; i < NUM_HOSTS; i++)); do
        ARRAY+=("{ _id: $i, host: \"mongo$((i + 1)).$DOMAIN_NAME:27017\" }")
    done
    RESULT_SETTINGS=$(IFS=,; echo "${ARRAY[*]}")

    #Apply settings
    sudo mongosh admin --tls --tlsCAFile /etc/mongodb/ssl/mongoCA.crt --tlsCertificateKeyFile /etc/mongodb/ssl/mongo.pem -u $MONGO_USER -p $MONGO_PASSWORD --host mongo1.example.io <<EOF
    rs.initiate( {
    _id : "agencyMeshAppMongodb",
    members: [ $RESULT_SETTINGS ]
    })
EOF
    sleep 2
    sudo mongosh admin --tls --tlsCAFile /etc/mongodb/ssl/mongoCA.crt --tlsCertificateKeyFile /etc/mongodb/ssl/mongo.pem -u $MONGO_USER -p $MONGO_PASSWORD --host mongo1.example.io <<EOF
    rs.conf()
EOF
fi
