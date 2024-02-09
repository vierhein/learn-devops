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

# Create public subnet
resource "aws_subnet" "public_subnet_one" {
  vpc_id                  = aws_vpc.vpc_one.id
  cidr_block              = var.public_subnet_one_cidr_block
  availability_zone       = "eu-central-1a"
  map_public_ip_on_launch = true

  tags = {
    Name = "public-subnet-one"
  }
}
# Create public subnet 2
resource "aws_subnet" "public_subnet_two" {
  vpc_id                  = aws_vpc.vpc_one.id
  cidr_block              = var.public_subnet_two_cidr_block
  availability_zone       = "eu-central-1b"
  map_public_ip_on_launch = true

  tags = {
    Name = "public-subnet-one"
  }
}

# Internet Gateway for public subnet
resource "aws_internet_gateway" "igw_one" {
  vpc_id = aws_vpc.vpc_one.id

  tags = {
    Name = "igw-one"
  }
}

# Attach Internet Gateway to public subnet
resource "aws_route_table" "public_route_table_one" {
  vpc_id = aws_vpc.vpc_one.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw_one.id
  }

  tags = {
    Name = "public-route-table-one"
  }
}

# Attach Internet Gateway to public subnet 2
resource "aws_route_table" "public_route_table_two" {
  vpc_id = aws_vpc.vpc_one.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw_one.id
  }

  tags = {
    Name = "public-route-table-two"
  }
}

resource "aws_route_table_association" "public_subnet_one_association" {
  subnet_id      = aws_subnet.public_subnet_one.id
  route_table_id = aws_route_table.public_route_table_one.id
}

resource "aws_route_table_association" "public_subnet_two_association" {
  subnet_id      = aws_subnet.public_subnet_two.id
  route_table_id = aws_route_table.public_route_table_two.id
}