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

# Render a part using a `template_file`
data "template_file" "conf" {
  template = "${file("${path.module}/templates/conf.tpl")}"
}

data "template_file" "script" {
  count = var.aws_instance_count
  template = "${file("${path.module}/templates/init.sh")}"

  vars = {
    num_host_current="${count.index + 1}",
    num_hosts="${var.aws_instance_count}",
    domain_name="${var.domain_name}",
    mongo_user="${var.mongo_user}",
    mongo_password="${var.mongo_password}",
  }
}

data "template_cloudinit_config" "config" {
  gzip          = true
  base64_encode = true
  count = var.aws_instance_count

  part {
    filename     = "conf.cfg"
    content_type = "text/cloud-config"
    content      = "${data.template_file.conf.rendered}"
  }
  
  part {
    filename     = "init.cfg"
    content_type = "text/x-shellscript"
    content       = element(data.template_file.script.*.rendered, count.index)
  }
}

resource "aws_instance" "mongodb_instance" {
  count                  = var.aws_instance_count
  ami                    = var.aws_ami_id
  instance_type          = var.aws_instance_type
  vpc_security_group_ids = [ aws_security_group.mongodb_sg.id ]
  subnet_id              = data.aws_subnet.mongo_db_private.id
  key_name               = aws_key_pair.ssh_key.key_name
  iam_instance_profile   = aws_iam_instance_profile.ec2_profile.name

  tags = {
    Name    = "mongodb-instance-${count.index + 1}"
  }

  user_data = element(data.template_cloudinit_config.config.*.rendered, count.index) 
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
    cidr_blocks = [ data.aws_vpc.mongo_db.cidr_block ]
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

# resource "aws_instance" "bastion_instance" {
#   ami                    = var.aws_ami_id
#   instance_type          = var.aws_instance_type
#   vpc_security_group_ids = [ aws_security_group.mongodb_sg.id ]
#   subnet_id              = data.aws_subnet.mongo_db_public.id
#   key_name               = aws_key_pair.ssh_key.key_name
#   tags = {
#     Name    = "bastion-instance"
#   } 
# }