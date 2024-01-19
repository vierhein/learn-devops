variable "container_config" {
  description = "Configuration for Docker containers"
  type        = list(object({
    name  = string
    image = string
    ports = list(number)
  }))
}

variable "env" {
  description = "Environment type (dev, prod, etc.)"
  type        = string
}
