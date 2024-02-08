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

resource "aws_route_table_association" "public_subnet_one_association" {
  subnet_id      = aws_subnet.public_subnet_one.id
  route_table_id = aws_route_table.public_route_table_one.id
}

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