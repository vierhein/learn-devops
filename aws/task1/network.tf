# create vpc
resource "aws_vpc" "vpc_one" {
  cidr_block           = var.vpc_cidr_block_one
  instance_tenancy     = "default"
  enable_dns_hostnames = true

  tags = {
    Name = "vpc-1"
  }
}

resource "aws_vpc" "vpc_two" {
  cidr_block           = var.vpc_cidr_block_two
  instance_tenancy     = "default"
  enable_dns_hostnames = true

  tags = {
    Name = "vpc-2"
  }
}

# create internet gateway and attach it to vpc
resource "aws_internet_gateway" "internet_gateway" {
  vpc_id = aws_vpc.vpc_one.id

  tags = {
    Name = "igw-1"
  }
}

resource "aws_internet_gateway" "internet_gateway" {
  vpc_id = aws_vpc.vpc_two.id

  tags = {
    Name = "igw-2"
  }
}

#############################################################
#Elastic IP for NAT Gateway And Create NAT Gateway
#############################################################

# resource "aws_eip" "nat_eip" {
# #   vpc        = true
#   depends_on = [aws_internet_gateway.internet_gateway]
# }

# #nat gateway
# resource "aws_nat_gateway" "nat_gateway" {
#   allocation_id = aws_eip.nat_eip.id
#   subnet_id     = aws_subnet.public_subnet_az1.id

#   tags = {
#     Name = "gw-NAT"
#   }

#   # To ensure proper ordering, it is recommended to add an explicit dependency
#   # on the Internet Gateway for the VPC.
#   depends_on = [aws_internet_gateway.internet_gateway]
# }


# use data source to get all avalablility zones in region
data "aws_availability_zones" "available_zones" {}

################################################################################
#Create Public Subnets, Route Table and Add Public Route
################################################################################

# create public subnet 
resource "aws_subnet" "public_subnet_one" {
  vpc_id                  = aws_vpc.vpc_one.id
  cidr_block              = var.public_subnet_one_cidr_block
  availability_zone       = data.aws_availability_zones.available_zones.names[0]
  map_public_ip_on_launch = true

  tags = {
    Name = "public-az1"
  }
}

# create route table and add public route
resource "aws_route_table" "public_route_table" {
  vpc_id = aws_vpc.vpc_one.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.internet_gateway.id
  }

  tags = {
    Name = "public-rt"
  }
}

# associate public subnet to "public route table"
resource "aws_route_table_association" "public_subnet_az1_rt_association" {
  subnet_id      = aws_subnet.public_subnet_one.id
  route_table_id = aws_route_table.public_route_table.id
}



################################################################################
#Create Data Subnets and Add to Private Route
################################################################################
# create  data subnet
resource "aws_subnet" "data_subnet_one" {
  vpc_id                  = aws_vpc.vpc_one.id
  cidr_block              = var.private_subnet_one_cidr_block
  availability_zone       = data.aws_availability_zones.available_zones.names[0]
  map_public_ip_on_launch = false

  tags = {
    Name = "data-az1"
  }
}

# create route table and add private route
# resource "aws_route_table" "private_route_table" {
#   vpc_id = aws_vpc.vpc_one.id

#   route {
#     cidr_block = "0.0.0.0/0"
#     nat_gateway_id = aws_nat_gateway.nat_gateway.id
#   }

#   tags = {
#     Name = "private-rt"
#   }
# }

# associate private subnet az1 to "private route table"
resource "aws_route_table_association" "data_subnet_az1_rt_association" {
  subnet_id      = aws_subnet.data_subnet_one.id
  route_table_id = aws_route_table.private_route_table.id
}