data "aws_secretsmanager_secret_version" "current" {
  secret_id = var.secret_manager_arn
}

locals {
  parsed_json_secret_manager = jsondecode(data.aws_secretsmanager_secret_version.current.secret_string)
  
  new_json_secret_settings = [
    for key, value in local.parsed_json_secret_manager :
    {
      name      = key
      valueFrom = join("", ["${var.secret_manager_arn}", ":", key,"::"])
    }
  ]

  transformed_secret_settings = jsonencode(local.new_json_secret_settings)
}