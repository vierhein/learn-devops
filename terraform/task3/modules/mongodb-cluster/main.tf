provider "aws" {
  region = var.region
}

resource "aws_instance" "mongodb_instance" {
  count         = var.instance_count
  ami           = var.ami_id
  instance_type = var.instance_type

  tags = {
    Name = "mongodb-instance-${count.index + 1}"
  }

  user_data = <<-EOF
              #!/bin/bash
              sudo yum update -y
              sudo amazon-linux-extras enable mongodb4.0
              sudo yum install -y mongodb-org
              sudo systemctl start mongod
              sudo systemctl enable mongod
              EOF
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
}

output "mongodb_connection_string" {
  value = join(",", [for i in aws_instance.mongodb_instance : "${i.public_ip}:27017"])
}
