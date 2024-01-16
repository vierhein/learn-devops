locals {
  backups = {
    schedule  = var.backup_schedule
    retention = var.backup_retention
  }
}

resource "aws_backup_vault" "mongodb-backup-vault" {
  name = "mongodb-backup-vault"
  tags = {
    Role    = "backup-vault"
  }
}

resource "aws_backup_plan" "mongodb-backup-plan" {
  name = "mongodb-backup-plan"

  rule {
    rule_name         = "backup-ec2-${local.backups.retention}-day-retention"
    target_vault_name = aws_backup_vault.mongodb-backup-vault.name
    schedule          = local.backups.schedule
    start_window      = var.backup_start_window
    completion_window = var.backup_completion_window

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

resource "aws_backup_selection" "mongodb-server-backup-selection" {
  iam_role_arn = aws_iam_role.mongodb-aws-backup-service-role.arn
  name         = "mongo-server-resources"
  plan_id      = aws_backup_plan.mongodb-backup-plan.id

  selection_tag {
    type  = "STRINGEQUALS"
    key   = "Backup"
    value = "true"
  }
}