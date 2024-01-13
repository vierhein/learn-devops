variable "region" {
  description = "AWS region where the MongoDB cluster will be deployed"
}

variable "instance_count" {
  description = "Number of MongoDB instances in the cluster"
}

variable "ami_id" {
  description = "AMI ID for the MongoDB instances"
}

variable "instance_type" {
  description = "Instance type for the MongoDB instances"
}