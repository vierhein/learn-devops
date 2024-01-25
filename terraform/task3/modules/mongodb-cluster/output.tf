output "mongodb_connection_string" {
  value = join(",", [for i in aws_instance.mongodb_instance : "${i.private_ip}"])
}

output "bastion_connection_string" {
  value = aws_instance.bastion_instance.public_ip
}