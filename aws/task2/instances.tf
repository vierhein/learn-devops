resource "aws_key_pair" "ssh_key" {
  key_name   = "ssh_key"
  public_key = file(var.public_key_path) 
}

resource "aws_instance" "instance_one" {
  ami                    = var.aws_ami_id
  instance_type          = var.aws_instance_type
  vpc_security_group_ids = [ aws_security_group.private_sg_one.id ]
  subnet_id              = aws_subnet.private_subnet_one.id
  key_name               = aws_key_pair.ssh_key.key_name

  tags = {
    Name    = "instance-one"
  }
}


