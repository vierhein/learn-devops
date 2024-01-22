aws_region         = "eu-central-1"
aws_instance_count = 1
aws_ami_id         = "ami-025a6a5beb74db87b" # Amazon Linux
aws_instance_type  = "t2.micro"
public_key_path    = "~/.ssh/id_ed25519.pub"

backup_schedule          = "cron(0 * ? * * *)" /* UTC Time */
backup_retention         = 7
backup_start_window      = 60
backup_completion_window = 120
backup_value             = "true"