data "aws_secretsmanager_secret_version" "current" {
  secret_id = var.secret_manager_arn
}

locals {
  parsed_json = jsondecode(data.aws_secretsmanager_secret_version.current.secret_string)
  
  transformed_json = [
    for key, value in local.parsed_json :
    {
      name      = key
      valueFrom = join("", ["${var.secret_manager_arn}", ":", key,"::"])
    }
  ]

  transformed_string = jsonencode(local.transformed_json)
}