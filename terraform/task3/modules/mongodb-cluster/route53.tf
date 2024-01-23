data "aws_vpc" "default" {
  default = true
}

resource "aws_route53_zone" "private" {
  name = "example.io"
  vpc {
    vpc_id     = data.aws_vpc.default.id
    vpc_region = "eu-central-1"
  }
}

resource "aws_route53_record" "mongodb_record" {
  count = var.aws_instance_count

  zone_id = aws_route53_zone.private.zone_id
  name    = "mongo${count.index + 1}" 

  type    = "A"
  ttl     = 300
  records = ["${aws_instance.mongodb_instance[count.index].private_ip}"]
}