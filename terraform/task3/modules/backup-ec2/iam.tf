data "aws_iam_policy_document" "example-aws-backup-service-assume-role-policy-doc" {
  statement {
    sid     = "AssumeServiceRole"
    actions = ["sts:AssumeRole"]
    effect  = "Allow"

    principals {
      type        = "Service"
      identifiers = ["backup.amazonaws.com"]
    }
  }
}

/* The policies that allow the backup service to take backups and restores */
data "aws_iam_policy" "aws-backup-service-policy" {
  arn = "arn:aws:iam::aws:policy/service-role/AWSBackupServiceRolePolicyForBackup"
}

data "aws_caller_identity" "current_account" {}

/* Roles for taking AWS Backups */
resource "aws_iam_role" "example-aws-backup-service-role" {
  name               = "ExampleAWSBackupServiceRole"
  description        = "Allows the AWS Backup Service to take scheduled backups"
  assume_role_policy = data.aws_iam_policy_document.example-aws-backup-service-assume-role-policy-doc.json

  tags = {
    Role    = "iam"
  }
}

resource "aws_iam_role_policy" "example-backup-service-aws-backup-role-policy" {
  policy = data.aws_iam_policy.aws-backup-service-policy.policy
  role   = aws_iam_role.example-aws-backup-service-role.name
}