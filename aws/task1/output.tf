output "instance_one" {
  value = aws_instance.instance_one.private_ip
}

output "instance_two" {
  value = aws_instance.instance_two.private_ip
}