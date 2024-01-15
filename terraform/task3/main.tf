provider "aws" {
  access_key = var.aws_access_key
  secret_key = var.aws_secret_key
  region     = var.aws_region
}

module "mongodb_cluster" {
  source              = "./modules/mongodb-cluster"
  aws_region              = var.aws_region
  aws_instance_count      = var.aws_instance_count
  aws_ami_id              = var.aws_ami_id 
  aws_instance_type       = var.aws_instance_type
  aws_access_key      = var.aws_access_key
  aws_secret_key      = var.aws_secret_key
  public_key_path     = var.public_key_path          
}

output "mongodb_connection_string" {
  value = module.mongodb_cluster.mongodb_connection_string
}
