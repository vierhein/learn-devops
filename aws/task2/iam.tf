resource "aws_iam_role" "ecs_task_execution_role" {
  name = "ecs_task_execution_role"
 
  assume_role_policy = <<EOF
{
 "Version": "2012-10-17",
 "Statement": [
   {
     "Action": "sts:AssumeRole",
     "Principal": {
       "Service": "ecs-tasks.amazonaws.com"
     },
     "Effect": "Allow",
     "Sid": ""
   }
 ]
}
EOF
}
 
resource "aws_iam_role_policy_attachment" "ecs_task_execution_role_policy_attachment" {
  role       = aws_iam_role.ecs_task_execution_role.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonECSTaskExecutionRolePolicy"
}

resource "aws_iam_role_policy_attachment" "ecs_get_secret_role_policy_attachment" {
  role       = aws_iam_role.ecs_task_execution_role.name
  policy_arn = "arn:aws:iam::aws:policy/SecretsManagerReadWrite"
}

# autoscale
resource "aws_iam_role" "ecs_autoscale_role" {
  name = "ecs_autoscale_role"
 
  assume_role_policy = <<EOF
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Sid": "",
            "Effect": "Allow",
            "Principal": {
                "Service": "application-autoscaling.amazonaws.com"
            },
            "Action": "sts:AssumeRole"
        }
    ]
}
EOF
}

resource "aws_iam_role_policy_attachment" "ecs_autoscale_role_policy_attachment" {
  role       = aws_iam_role.ecs_autoscale_role.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonEC2ContainerServiceAutoscaleRole"
}


# data "aws_iam_policy_document" "assume_ecs_task_execution_role" {
#   statement {
#     effect = "Allow"

#     principals {
#       type        = "Service"
#       identifiers = ["ecs-tasks.amazonaws.com"]
#     }

#     actions = ["sts:AssumeRole"]
#   }
# }

# resource "aws_iam_role" "ecs_task_execution_role" {
#   name               = "ecs_task_execution_role"
#   assume_role_policy = data.aws_iam_policy_document.assume_ecs_task_execution_role.json
# }

# data "aws_iam_policy_document" "policy_task_execution_role" {
#   statement {
#     effect    = "Allow"
#     actions   = [
#         "ecr:GetAuthorizationToken",
#         "ecr:BatchCheckLayerAvailability",
#         "ecr:GetDownloadUrlForLayer",
#         "ecr:BatchGetImage"
#     ]
#     resources = ["*"]
#   }
# }

# resource "aws_iam_policy" "policy_task_execution_role" {
#   name        = "policy_task_execution_role"
#   policy      = data.aws_iam_policy_document.policy_task_execution_role.json
# }

# resource "aws_iam_role_policy_attachment" "test-attach" {
#   role       = aws_iam_role.ecs_task_execution_role.name
#   policy_arn = aws_iam_policy.policy_task_execution_role.arn
# }
