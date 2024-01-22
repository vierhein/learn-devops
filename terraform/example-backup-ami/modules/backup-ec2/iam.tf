data "aws_iam_policy_document" "mongodb-aws-backup-service-assume-role-policy-doc" {
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

data "aws_iam_policy" "aws-backup-service-policy" {
  arn = "arn:aws:iam::aws:policy/service-role/AWSBackupServiceRolePolicyForBackup"
}

data "aws_caller_identity" "current_account" {}

resource "aws_iam_role" "mongodb-aws-backup-service-role" {
  name               = "MongodbAWSBackupServiceRole"
  description        = "Allows the AWS Backup Service to take scheduled backups"
  assume_role_policy = data.aws_iam_policy_document.mongodb-aws-backup-service-assume-role-policy-doc.json

  tags = {
    Role    = "iam"
  }
}

resource "aws_iam_role_policy" "mongodb-backup-service-aws-backup-role-policy" {
  policy = data.aws_iam_policy.aws-backup-service-policy.policy
  role   = aws_iam_role.mongodb-aws-backup-service-role.name
}