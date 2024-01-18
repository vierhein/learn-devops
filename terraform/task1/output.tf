output "passwords" {
  sensitive = true
  value = random_password.generated_passwords[*].result
}