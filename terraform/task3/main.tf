module "mongodb_cluster" {
  source              = "./modules/mongodb-cluster"
  aws_region          = var.aws_region
  aws_instance_count  = var.aws_instance_count
  aws_ami_id          = var.aws_ami_id 
  aws_instance_type   = var.aws_instance_type
  aws_access_key      = var.aws_access_key
  aws_secret_key      = var.aws_secret_key
  public_key_path     = var.public_key_path
  backup_value        = var.backup_value  
}

module "backup_ec2" {
  source                   = "./modules/backup-ec2"
  aws_region               = var.aws_region
  aws_access_key           = var.aws_access_key
  aws_secret_key           = var.aws_secret_key
  backup_schedule          = var.backup_schedule
  backup_retention         = var.backup_retention
  backup_start_window      = var.backup_start_window
  backup_completion_window = var.backup_completion_window
}
