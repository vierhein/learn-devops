data "aws_iam_policy_document" "ec2_instance_assume_role_policy"{
  statement {
    effect  = "Allow"
    actions = ["sts:AssumeRole"]
    principals {
      type        = "Service"
      identifiers = ["ec2.amazonaws.com",]
    }
  }

}

data "aws_iam_policy_document" "iam_policy_ec2_instance_document"{
  statement {
    effect = "Allow"
    actions = ["ec2:DescribeInstances",
               "ec2:DescribeTags",
               "s3:GetObject",
               "s3:PutObject",
               "s3:DeleteObject",
               "s3:DeleteObjects"]
    resources = ["arn:aws:s3:::backup-mongo-andrew2/*"]
  }

}

resource "aws_iam_role" "ec2_instance_role" {
  name               = "ec2_instance_role"
  assume_role_policy = data.aws_iam_policy_document.ec2_instance_assume_role_policy.json
  inline_policy {
    name   = "policy-8675308"
    policy = data.aws_iam_policy_document.iam_policy_ec2_instance_document.json
  }
}

resource "aws_iam_instance_profile" "ec2_profile" {
  name = "ec2_profile"
  role = aws_iam_role.ec2_instance_role.name
}