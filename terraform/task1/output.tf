output "passwords" {
  value = nonsensitive(join(",", [for i in random_password.generated_passwords : "${i.result}"]))
}