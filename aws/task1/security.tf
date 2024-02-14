# Security Group for vpc one
resource "aws_security_group" "private_sg_one" {
  vpc_id = aws_vpc.vpc_one.id

  lifecycle {
    create_before_destroy = true
  }

  tags = {
    Name = "private-sg-one"
  }
}
resource "aws_security_group_rule" "sg_one_allow_ssh" {
  type              = "ingress"
  from_port         = 22
  to_port           = 22
  protocol          = "tcp"
  cidr_blocks       = ["0.0.0.0/0"]
  security_group_id = aws_security_group.private_sg_one.id
}

resource "aws_security_group_rule" "sg_one_allow_all" {
  type              = "egress"
  from_port         = 0
  to_port           = 0
  protocol          = "-1"
  cidr_blocks       = ["0.0.0.0/0"]
  security_group_id = aws_security_group.private_sg_one.id
}



# Security Group for vpc two
resource "aws_security_group" "private_sg_two" {
  vpc_id = aws_vpc.vpc_two.id

  lifecycle {
    create_before_destroy = true
  }

  tags = {
    Name = "private-sg-two"
  }
}

resource "aws_security_group_rule" "sg_two_allow_ssh" {
  type              = "ingress"
  from_port         = 22
  to_port           = 22
  protocol          = "tcp"
  cidr_blocks       = ["0.0.0.0/0"]
  security_group_id = aws_security_group.private_sg_two.id
}

resource "aws_security_group_rule" "sg_two_allow_all" {
  count             = var.access_each_other ? 1 : 0
  type              = "egress"
  from_port         = 0
  to_port           = 0
  protocol          = "-1"
  cidr_blocks       = ["0.0.0.0/0"]
  security_group_id = aws_security_group.private_sg_two.id
}