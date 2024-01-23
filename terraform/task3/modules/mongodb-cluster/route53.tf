resource "aws_route53_zone" "main" {
  name = "example.io"
}

resource "aws_route53_record" "mongodb_record" {
  count = var.aws_instance_count

  zone_id = aws_route53_zone.main.zone_id
  name    = "mongo${count.index + 1}" 

  type    = "A"
  ttl     = 300
  records = ["${aws_instance.mongodb_instance[count.index].private_ip}"]
}