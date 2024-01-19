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