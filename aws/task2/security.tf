# Security Group for instances in public subnet
resource "aws_security_group" "public_sg_one" {
  vpc_id = aws_vpc.vpc_one.id

  ingress {
        protocol    = "tcp"
        from_port   = var.app_port
        to_port     = var.app_port
        cidr_blocks = ["0.0.0.0/0"]
    }

    egress {
        protocol    = "-1"
        from_port   = 0
        to_port     = 0
        cidr_blocks = ["0.0.0.0/0"]
    }

  tags = {
    Name = "public-sg-one"
  }
}