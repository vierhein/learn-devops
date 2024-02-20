# create vpc

data "aws_availability_zones" "available" {
}

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
resource "aws_subnet" "public_subnet" {
  count                   = var.subnet_count
  vpc_id                  = aws_vpc.vpc_one.id
  cidr_block              = cidrsubnet(var.vpc_cidr_block_one, 4, count.index)
  availability_zone       = data.aws_availability_zones.available.names[count.index]
  map_public_ip_on_launch = true

  tags = {
    Name = "public-subnet-${count.index + 1}"
  }
}

# Internet Gateway for public subnet
resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.vpc_one.id

  tags = {
    Name = "igw"
  }
}

resource "aws_route_table" "public_route_table" {
  vpc_id = aws_vpc.vpc_one.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw.id
  }

  tags = {
    Name = "public-route-table"
  }
}

resource "aws_route_table_association" "public_subnet_association" {
  count          = var.subnet_count
  subnet_id      = element(aws_subnet.public_subnet.*.id, count.index)
  route_table_id = aws_route_table.public_route_table.id
}