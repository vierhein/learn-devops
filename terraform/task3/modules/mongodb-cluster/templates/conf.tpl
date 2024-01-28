yum_repos:
  # The name of the repository
  epel-testing:
    # Any repository configuration options
    # See: man yum.conf
    #
    # This one is required!
    baseurl: https://repo.mongodb.org/yum/amazon/2023/mongodb-org/7.0/x86_64/
    enabled: true
    failovermethod: priority
    gpgcheck: true
    gpgkey: https://www.mongodb.org/static/pgp/server-7.0.asc
    name: MongoDB Repository

packages:
  - mongodb-org-7.0.3
  - mongodb-org-database-7.0.3 
  - mongodb-org-server-7.0.3 
  - mongodb-mongosh-shared-openssl3 
  - mongodb-org-mongos-7.0.3 
  - mongodb-org-tools-7.0.3

