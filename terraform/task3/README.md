export TF_VAR_aws_access_key="" <br>
export TF_VAR_aws_secret_key="" <br>

terraform plan -var-file=env/minimal.tfvars <br>
terraform apply -var-file=env/minimal.tfvars <br>