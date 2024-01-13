variable "aws_access_key" {}
variable "aws_secret_key" {}

provider "aws" {
  access_key = var.aws_access_key
  secret_key = var.aws_secret_key
  region     = "eu-central-1"
}

module "mongodb_cluster" {
  source          = "./modules/mongodb-cluster"
  region          = "eu-central-1"
  instance_count  = 1
  ami_id          = "ami-025a6a5beb74db87b"  # Amazon Linux
  instance_type   = "t2.micro"
  aws_access_key      = var.aws_access_key
  aws_secret_key      = var.aws_secret_key               
}

output "mongodb_connection_string" {
  value = module.mongodb_cluster.mongodb_connection_string
}
