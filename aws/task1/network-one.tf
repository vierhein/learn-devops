# create vpc
resource "aws_vpc" "vpc_one" {
  cidr_block           = var.vpc_cidr_block_one
  instance_tenancy     = "default"
  enable_dns_support   = true
  enable_dns_hostnames = true

  tags = {
    Name = "vpc-one"
  }
}

# Create private subnet
resource "aws_subnet" "private_subnet_one" {
  vpc_id                  = aws_vpc.vpc_one.id
  cidr_block              = var.private_subnet_one_cidr_block
  availability_zone       = "eu-central-1b"

  tags = {
    Name = "private-subnet-one"
  }
}

resource "aws_route_table" "private_route_table_one" {
  vpc_id = aws_vpc.vpc_one.id

  tags = {
    Name = "private-route-table-one"
  }
}

resource "aws_route_table_association" "private_subnet_one_association" {
  subnet_id      = aws_subnet.private_subnet_one.id
  route_table_id = aws_route_table.private_route_table_one.id
}

