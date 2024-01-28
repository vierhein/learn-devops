output "mongodb_connection_string" {
  value = module.mongodb_cluster.mongodb_connection_string
}

# output "bastion_connection_string" {
#   value = module.mongodb_cluster.bastion_connection_string
# }