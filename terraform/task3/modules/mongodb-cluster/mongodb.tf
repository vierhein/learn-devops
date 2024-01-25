resource "aws_key_pair" "ssh_key" {
  key_name   = "ssh_key"
  public_key = file(var.public_key_path) 
}

data "aws_subnet" "mongo_db_public" {
  filter {
    name = "tag:Name"
    values = ["mongo-db-subnet-public1-eu-central-1a"]
  }
}

data "aws_subnet" "mongo_db_private" {
  filter {
    name = "tag:Name"
    values = ["mongo-db-subnet-private1-eu-central-1a"]
  }
}

resource "aws_instance" "bastion_instance" {
  ami                    = var.aws_ami_id
  instance_type          = var.aws_instance_type
  vpc_security_group_ids = [ aws_security_group.mongodb_sg.id ]
  subnet_id              = data.aws_subnet.mongo_db_public.id
  key_name               = aws_key_pair.ssh_key.key_name
  tags = {
    Name    = "bastion-instance"
  } 
}

resource "aws_instance" "mongodb_instance" {
  count                  = var.aws_instance_count
  ami                    = var.aws_ami_id
  instance_type          = var.aws_instance_type
  vpc_security_group_ids = [ aws_security_group.mongodb_sg.id ]
  subnet_id              = data.aws_subnet.mongo_db_private.id
  key_name               = aws_key_pair.ssh_key.key_name

  tags = {
    Name    = "mongodb-instance-${count.index + 1}"
  } 
}

resource "aws_security_group" "mongodb_sg" {
  name        = "mongo-sg"
  description = "MongoDB Security Group"
  vpc_id      = data.aws_vpc.mongo_db.id

  ingress {
    description = "TLS from VPC"
    from_port   = 27017
    to_port     = 27017
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    description = "ssh"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }

  tags = {
    Name = "sg-mongodb"
  }
}

resource "null_resource" "host_provisioning" {
  count = "${var.aws_instance_count}"

  connection {
    user = "ec2-user"
    host = "${element(aws_instance.mongodb_instance.*.private_ip, count.index)}"
    bastion_user = "ec2-user"
    bastion_host = aws_instance.bastion_instance.public_ip
    bastion_private_key = file(var.private_key_path)
  }

  provisioner "file" {
    source      = var.cert_path
    destination = "/tmp"
  }

  provisioner "remote-exec" {
    inline = [
      "export num_host_current=${count.index + 1}",
      "export num_hosts=${var.aws_instance_count}",
      "export domain_name=${var.domain_name}",
      "export mongo_user=${var.mongo_user}",
      "export mongo_password=${var.mongo_password}",
      "${file("${path.module}/scripts/test.sh")}",
    ]
  }
}