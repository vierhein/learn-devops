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

resource "null_resource" "host_provisioning" {
  count = "${var.aws_instance_count}"

  connection {
    user = "ec2-user"
    host = "${element(aws_instance.mongodb_instance.*.public_ip, count.index)}"
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