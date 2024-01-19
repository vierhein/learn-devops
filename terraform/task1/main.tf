provider "random" {}

resource "random_password" "generated_passwords" {
  count = var.num_passwords

  length           = var.password_length
  special          = var.special_characters
  upper            = var.upper_case
  override_special = "!@#$%^&*()_-+=[]{}|;:'\",.<>?/"
}
