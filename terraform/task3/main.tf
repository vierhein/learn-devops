module "mongodb_cluster" {
  source              = "./modules/mongodb-cluster"
  aws_region          = var.aws_region
  aws_instance_count  = var.aws_instance_count
  aws_ami_id          = var.aws_ami_id 
  aws_instance_type   = var.aws_instance_type
  aws_access_key      = var.aws_access_key
  aws_secret_key      = var.aws_secret_key
  public_key_path     = var.public_key_path
  domain_name         = var.domain_name
  mongo_user          = var.mongo_user
  mongo_password      = var.mongo_password 
}
