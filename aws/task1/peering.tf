resource "aws_vpc_peering_connection" "foo" {
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

