# create vpc
resource "aws_vpc" "vpc_two" {
  cidr_block       = var.vpc_cidr_block_two
  instance_tenancy = "default"

  tags = {
    Name = "vpc-two"
  }
}

# Create public subnet
resource "aws_subnet" "public_subnet_two" {
  vpc_id                  = aws_vpc.vpc_two.id
  cidr_block              = var.public_subnet_two_cidr_block
  availability_zone       = "eu-central-1a"
  map_public_ip_on_launch = true

  tags = {
    Name = "public-subnet"
  }
}

# Create private subnet
resource "aws_subnet" "private_subnet_two" {
  vpc_id                  = aws_vpc.vpc_two.id
  cidr_block              = var.private_subnet_two_cidr_block
  availability_zone       = "eu-central-1b"

  tags = {
    Name = "private-subnet"
  }
}

# Internet Gateway for public subnet
resource "aws_internet_gateway" "igw_two" {
  vpc_id = aws_vpc.vpc_two.id

  tags = {
    Name = "igw-two"
  }
}

# Attach Internet Gateway to public subnet
resource "aws_route_table" "public_route_table_two" {
  vpc_id = aws_vpc.vpc_two.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw_two.id
  }

  tags = {
    Name = "public-route-table-two"
  }
}

resource "aws_route_table" "private_route_table_two" {
  vpc_id = aws_vpc.vpc_two.id

  tags = {
    Name = "private-route-table-two"
  }
}

resource "aws_route_table_association" "public_subnet_two_association" {
  subnet_id      = aws_subnet.public_subnet_two.id
  route_table_id = aws_route_table.public_route_table_two.id
}

resource "aws_route_table_association" "private_subnet_two_association" {
  subnet_id      = aws_subnet.private_subnet_two.id
  route_table_id = aws_route_table.private_route_table_two.id
}

# Security Group for instances in private subnet
resource "aws_security_group" "private_sg_two" {
  vpc_id = aws_vpc.vpc_two.id

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "private-sg"
  }
}

# Security Group for instances in public subnet
resource "aws_security_group" "public_sg_two" {
  vpc_id = aws_vpc.vpc_two.id

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "public-sg"
  }
}
