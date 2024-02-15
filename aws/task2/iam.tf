data "aws_iam_policy_document" "assume_ecs_task_execution_role" {
  statement {
    effect = "Allow"

    principals {
      type        = "Service"
      identifiers = ["ecs-tasks.amazonaws.com"]
    }

    actions = ["sts:AssumeRole"]
  }
}

resource "aws_iam_role" "ecs_task_execution_role" {
  name               = "ecs_task_execution_role"
  assume_role_policy = data.aws_iam_policy_document.assume_ecs_task_execution_role.json
}

data "aws_iam_policy_document" "policy_task_execution_role" {
  statement {
    effect    = "Allow"
    actions   = [
        "ecr:GetAuthorizationToken",
        "ecr:BatchCheckLayerAvailability",
        "ecr:GetDownloadUrlForLayer",
        "ecr:BatchGetImage"
    ]
    resources = ["*"]
  }
}

data "aws_iam_policy_document" "policy_secretmanager_read_role" {
  statement {
    effect    = "Allow"
    actions   = [
        "secretsmanager:GetResourcePolicy",
        "secretsmanager:GetSecretValue",
        "secretsmanager:DescribeSecret",
        "secretsmanager:ListSecretVersionIds"
    ]
    resources = ["arn:aws:secretsmanager:eu-central-1:357197750522:secret:prod2-2lk6i2"]
  }
}

resource "aws_iam_policy" "policy_task_execution_role" {
  name        = "policy_task_execution_role"
  policy      = data.aws_iam_policy_document.policy_task_execution_role.json
}

resource "aws_iam_policy" "policy_secretmanager_read_role" {
  name        = "policy_secretmanager_read"
  policy      = data.aws_iam_policy_document.policy_secretmanager_read_role.json
}

resource "aws_iam_role_policy_attachment" "policy_task_execution_role-attach" {
  role       = aws_iam_role.ecs_task_execution_role.name
  policy_arn = aws_iam_policy.policy_task_execution_role.arn
}

resource "aws_iam_role_policy_attachment" "policy_secretmanager_read_role-attach" {
  role       = aws_iam_role.ecs_task_execution_role.name
  policy_arn = aws_iam_policy.policy_secretmanager_read_role.arn
}


# autoscale

data "aws_iam_policy_document" "assume_ecs_autoscale_role" {
  statement {
    effect = "Allow"

    principals {
      type        = "Service"
      identifiers = ["application-autoscaling.amazonaws.com"]
    }

    actions = ["sts:AssumeRole"]
  }
}

resource "aws_iam_role" "ecs_autoscale_role" {
  name               = "ecs_autoscale_role"
  assume_role_policy = data.aws_iam_policy_document.assume_ecs_autoscale_role.json
}

data "aws_iam_policy_document" "policy_autoscale_role" {
  statement {
    effect    = "Allow"
    actions   = [
        "ecs:DescribeServices",
        "ecs:UpdateService"
    ]
    resources = ["arn:aws:ecs:eu-central-1:357197750522:cluster/cb-cluster"]
  }
}

data "aws_iam_policy_document" "policy_cloudwatch_role" {
  statement {
    effect    = "Allow"
    actions   = [
        "cloudwatch:DescribeAlarms",
        "cloudwatch:PutMetricAlarm"
    ]
    resources = [
      "arn:aws:cloudwatch:eu-central-1:357197750522:alarm:cb_cpu_utilization_low",
      "arn:aws:cloudwatch:eu-central-1:357197750522:alarm:cb_cpu_utilization_high"
    ]
  }
}

resource "aws_iam_policy" "policy_autoscale_role" {
  name        = "policy_autoscale_role"
  policy      = data.aws_iam_policy_document.policy_autoscale_role.json
}

resource "aws_iam_policy" "policy_cloudwatch_role" {
  name        = "policy_cloudwatch_role"
  policy      = data.aws_iam_policy_document.policy_cloudwatch_role.json
}

resource "aws_iam_role_policy_attachment" "policy_autoscale_role_attach" {
  role       = aws_iam_role.ecs_autoscale_role.name
  policy_arn = aws_iam_policy.policy_autoscale_role.arn
}

resource "aws_iam_role_policy_attachment" "policy_cloudwatch_role_attach" {
  role       = aws_iam_role.ecs_autoscale_role.name
  policy_arn = aws_iam_policy.policy_cloudwatch_role.arn
}