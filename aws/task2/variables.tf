variable "aws_access_key" {}
variable "aws_secret_key" {}
variable "aws_region" {}

variable "vpc_cidr_block_one" {}
variable "public_subnet_one_cidr_block" {}
variable "public_subnet_two_cidr_block" {}

variable "app_image" {
    description = "Docker image to run in the ECS cluster"
    default = "357197750522.dkr.ecr.eu-central-1.amazonaws.com/test:latest"
}
variable "app_port" {
    description = "Port exposed by the docker image to redirect traffic to"
    default = 80
}
variable "app_count" {
    description = "Number of docker containers to run"
    default = 1
}
variable "fargate_cpu" {
    default = "256"
}
variable "fargate_memory" {
    default = "512"
}

variable "secret_manager_name" {
    description = "Secret Manager name"
    default = "arn:aws:secretsmanager:eu-central-1:357197750522:secret:test-57GDMj"
}
