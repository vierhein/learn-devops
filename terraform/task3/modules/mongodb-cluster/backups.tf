locals {
  backups = {
    schedule  = "cron(0 * ? * * *)" /* UTC Time */
    retention = 7 // days
  }
}

resource "aws_backup_vault" "example-backup-vault" {
  name = "mongodb-backup-vault"
  tags = {
    Project = "test"
    Role    = "backup-vault"
  }
}

resource "aws_backup_plan" "example-backup-plan" {
  name = "mongodb-backup-plan"

  rule {
    rule_name         = "every-hour-${local.backups.retention}-day-retention"
    target_vault_name = aws_backup_vault.example-backup-vault.name
    schedule          = local.backups.schedule
    start_window      = 60
    completion_window = 120

    lifecycle {
      delete_after = local.backups.retention
    }

    recovery_point_tags = {
      Role    = "backup"
      Creator = "aws-backups"
    }
  }

  tags = {
    Role    = "backup"
  }
}

resource "aws_backup_selection" "example-server-backup-selection" {
  iam_role_arn = aws_iam_role.example-aws-backup-service-role.arn
  name         = "mongo-server-resources"
  plan_id      = aws_backup_plan.example-backup-plan.id

  selection_tag {
    type  = "STRINGEQUALS"
    key   = "Backup"
    value = "true"
  }
}