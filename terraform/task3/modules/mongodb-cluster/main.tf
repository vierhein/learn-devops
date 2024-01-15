provider "aws" {
  region     = var.aws_region
  access_key = var.aws_access_key
  secret_key = var.aws_secret_key
}
resource "aws_key_pair" "ssh_key" {
  key_name   = "ssh_key"
  public_key = file(var.public_key_path) 
}

resource "aws_instance" "mongodb_instance" {
  count                  = var.aws_instance_count
  ami                    = var.aws_ami_id
  instance_type          = var.aws_instance_type
  vpc_security_group_ids = [ aws_security_group.mongodb_sg.id ]
  key_name               = aws_key_pair.ssh_key.key_name

  tags = {
    Name = "mongodb-instance-${count.index + 1}"
  }

  user_data = file("${path.module}/scripts/init.sh")
}

resource "aws_security_group" "mongodb_sg" {
  name        = "mongodb-sg"
  description = "MongoDB Security Group"

  ingress {
    from_port   = 27017
    to_port     = 27017
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 27017
    to_port     = 27017
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

output "mongodb_connection_string" {
  value = join(",", [for i in aws_instance.mongodb_instance : "${i.public_ip}:27017"])
}
