output "mongodb_connection_string" {
  value = join(",", [for i in aws_instance.mongodb_instance : "${i.public_ip}:27017"])
}