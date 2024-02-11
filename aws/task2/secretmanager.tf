resource "aws_secretsmanager_secret" "cb_secret" {
  name = "cb-secret"
}

resource "aws_secretsmanager_secret_version" "cb_secret_version" {
  secret_id     = aws_secretsmanager_secret.cb_secret.id
  secret_string = jsonencode({
    key1 = "first-secret-value",
    key2 = "second-secret-value"
  })
}