# create vpc
resource "aws_vpc" "vpc_one" {
  cidr_block           = var.vpc_cidr_block_one
  instance_tenancy     = "default"
  enable_dns_hostnames = true

  tags = {
    Name = "vpc-1"
  }
}

