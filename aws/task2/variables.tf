variable "aws_access_key" {}
variable "aws_secret_key" {}
variable "aws_region" {}

variable "vpc_cidr_block_one" {}
variable "public_subnet_one_cidr_block" {}
variable "public_subnet_two_cidr_block" {}

variable "app_image" {
    default = "357197750522.dkr.ecr.eu-central-1.amazonaws.com/test:latest"
}
variable "app_port" {
    default = 80
}
variable "app_desired" {
    default = 3
}
variable "fargate_cpu" {
    default = "256"
}
variable "fargate_memory" {
    default = "512"
}
