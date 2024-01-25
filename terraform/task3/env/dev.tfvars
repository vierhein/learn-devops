aws_region         = "eu-central-1"
aws_instance_count = 2
aws_ami_id         = "ami-025a6a5beb74db87b" # Amazon Linux
aws_instance_type  = "t2.micro"
public_key_path    = "~/.ssh/id_ed25519.pub"
private_key_path   = "~/.ssh/id_ed25519"
cert_path          = "~/cert"

domain_name        = "example.io"
mongo_user         = "admin"
mongo_password     = "password"