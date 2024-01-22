resource "aws_key_pair" "ssh_key" {
  key_name   = "ssh_key"
  public_key = file(var.public_key_path) 
}

resource "aws_instance" "mongodb_instance" {
  count                  = var.aws_instance_count
  ami                    = var.aws_ami_id
  instance_type          = var.aws_instance_type
#   vpc_security_group_ids = [ aws_security_group.mongodb_sg.id ]
  key_name               = aws_key_pair.ssh_key.key_name

  tags = {
    Name    = "mongodb-instance-${count.index + 1}"
  }

  user_data = base64encode(templatefile("${path.module}/scripts/test.sh", {dns_name = "mongo${count.index + 1}.example.io"}))

  provisioner "file" {
    source      = "${path.module}/cert"
    destination = "/tmp"

    connection {
      type        = "ssh"
      user        = "ec2-user"
      host        = "${self.public_dns}"
    }
  }
}