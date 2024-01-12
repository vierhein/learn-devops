variable "container_config" {
  description = "Configuration for Docker containers"
  type        = list(object({
    name  = string
    image = string
    ports = list(number)
  }))
}

variable "environment" {
  description = "Environment type (dev, prod, etc.)"
  type        = string
}
