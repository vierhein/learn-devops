# create vpc
resource "aws_vpc" "vpc_two" {
  cidr_block       = var.vpc_cidr_block_two
  instance_tenancy = "default"
  enable_dns_support   = true
  enable_dns_hostnames = true

  tags = {
    Name = "vpc-two"
  }
}

# Create private subnet
resource "aws_subnet" "private_subnet_two" {
  vpc_id                  = aws_vpc.vpc_two.id
  cidr_block              = cidrsubnet(var.vpc_cidr_block_two, 4, var.subnet_count)
  availability_zone       = "eu-central-1b"

  tags = {
    Name = "private-subnet-two"
  }
}

resource "aws_route_table" "private_route_table_two" {
  vpc_id = aws_vpc.vpc_two.id

  tags = {
    Name = "private-route-table-two"
  }
}

resource "aws_route_table_association" "private_subnet_two_association" {
  subnet_id      = aws_subnet.private_subnet_two.id
  route_table_id = aws_route_table.private_route_table_two.id
}
