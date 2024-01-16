export TF_VAR_aws_access_key=""
export TF_VAR_aws_secret_key=""

terraform plan -var-file=minimal.tfvars
terraform apply -var-file=minimal.tfvars