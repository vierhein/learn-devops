resource "aws_vpc_peering_connection" "vpc_peering" {
  peer_vpc_id   = aws_vpc.vpc_one.id
  vpc_id        = aws_vpc.vpc_two.id
  auto_accept   = true
  
  accepter {
    allow_remote_vpc_dns_resolution = true
  }

  requester {
    allow_remote_vpc_dns_resolution = true
  }
}

resource "aws_route" "route_to_vpc_one" {
  route_table_id            = aws_route_table.private_route_table_one.id
  destination_cidr_block    = aws_subnet.private_subnet_two.cidr_block
  vpc_peering_connection_id = aws_vpc_peering_connection.vpc_peering.id
}

resource "aws_route" "route_to_vpc_two" {
  route_table_id            = aws_route_table.private_route_table_two.id
  destination_cidr_block    = aws_subnet.private_subnet_one.cidr_block
  vpc_peering_connection_id = aws_vpc_peering_connection.vpc_peering.id
}
