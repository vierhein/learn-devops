#!/bin/bash
MONGO_USER="admin"
MONGO_PASSWORD="password"
S3_BACKUP_BUCKET="backup-mongo-andrew2"
DNS_NAME="arbitr.example.io"

sudo hostnamectl set-hostname $DNS_NAME

# Start MongoDB
sudo systemctl daemon-reload
sudo systemctl start mongod
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
sudo aws s3 cp s3://$S3_BACKUP_BUCKET/mongoCA.crt /etc/mongodb/ssl
sudo aws s3 cp s3://$S3_BACKUP_BUCKET/mongo.pem /etc/mongodb/ssl

sudo mkdir -p /var/lib/mongo/arb

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
  dbPath: /var/lib/mongo/arb

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

sleep 60

sudo mongosh admin --tls --tlsCAFile /etc/mongodb/ssl/mongoCA.crt --tlsCertificateKeyFile /etc/mongodb/ssl/mongo.pem -u $MONGO_USER -p $MONGO_PASSWORD --host mongo1.example.io <<EOF
db.adminCommand({
  "setDefaultRWConcern" : 1,
  "defaultWriteConcern" : {
    "w" : 2
  },
  "defaultReadConcern" : { "level" : "majority" }
})
EOF

sleep 2
sudo mongosh admin --tls --tlsCAFile /etc/mongodb/ssl/mongoCA.crt --tlsCertificateKeyFile /etc/mongodb/ssl/mongo.pem -u $MONGO_USER -p $MONGO_PASSWORD --host mongo1.example.io <<EOF
rs.addArb("arbitr.example.io:27017")
EOF