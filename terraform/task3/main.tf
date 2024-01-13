provider "aws" {
  region = "us-east-1"
}

module "mongodb_cluster" {
  source          = "./modules/mongodb-cluster"
  region          = "us-east-1"
  instance_count  = 3
  ami_id          = ""  #TO DO
  instance_type   = "t2.micro"               
}

output "mongodb_connection_string" {
  value = module.mongodb_cluster.mongodb_connection_string
}
