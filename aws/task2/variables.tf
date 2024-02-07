variable "aws_access_key" {}
variable "aws_secret_key" {}

variable "aws_region" {}
variable "aws_instance_count" {}
variable "aws_ami_id" {}
variable "aws_instance_type" {}
variable "public_key_path" {}

variable "vpc_cidr_block_one" {}
variable "public_subnet_one_cidr_block" {}
variable "private_subnet_one_cidr_block" {}

variable "ec2_task_execution_role_name" {
    description = "ECS task execution role name"
    default = "myEcsTaskExecutionRole"
}

variable "ecs_auto_scale_role_name" {
    description = "ECS auto scale role name"
    default = "myEcsAutoScaleRole"
}
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

variable "az_count" {
    description = "Number of AZs to cover in a given region"
    default = "2"
}