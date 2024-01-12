provider "random" {}

variable "num_passwords" {
  description = "Number of passwords to generate"
  type        = number
  default     = 3
}

variable "password_length" {
  description = "Length of each password"
  type        = number
  default     = 12
}

variable "special_characters" {
  description = "Use special characters in passwords"
  type        = bool
  default     = true
}

variable "upper_case" {
  description = "Use upper case letters in passwords"
  type        = bool
  default     = true
}

resource "random_password" "generated_passwords" {
  count = var.num_passwords

  length           = var.password_length
  special          = var.special_characters
  upper            = var.upper_case
  override_special = "!@#$%^&*()_-+=[]{}|;:'\",.<>?/"
}

output "passwords" {
  sensitive = true
  value = random_password.generated_passwords[*].result
}
