resource "aws_security_group" "public_sg_one" {
  vpc_id = aws_vpc.vpc_one.id

  lifecycle {
    create_before_destroy = true
  }

  tags = {
    Name = "public-sg-one"
  }
}

resource "aws_security_group_rule" "sg_one_allow_ssh" {
  type              = "ingress"
  from_port         = var.app_port
  to_port           = var.app_port
  protocol          = "tcp"
  cidr_blocks       = ["0.0.0.0/0"]
  security_group_id = aws_security_group.public_sg_one.id
}

resource "aws_security_group_rule" "sg_one_egress_allow_all" {
  type              = "egress"
  from_port         = 0
  to_port           = 0
  protocol          = "-1"
  cidr_blocks       = ["0.0.0.0/0"]
  security_group_id = aws_security_group.public_sg_one.id
}