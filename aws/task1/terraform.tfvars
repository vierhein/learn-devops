aws_region         = "eu-central-1"
aws_instance_count = 1
aws_ami_id         = "ami-025a6a5beb74db87b" # Amazon Linux
aws_instance_type  = "t2.micro"
public_key_path    = "~/.ssh/id_ed25519.pub"

vpc_cidr_block_one = "10.1.0.0/24"
vpc_cidr_block_two = "10.2.0.0/24"

public_subnet_one_cidr_block   = "10.1.0.0/28"
private_subnet_one_cidr_block  = "10.1.128.0/28"
public_subnet_two_cidr_block   = "10.2.0.0/28"
private_subnet_two_cidr_block  = "10.2.128.0/28"
