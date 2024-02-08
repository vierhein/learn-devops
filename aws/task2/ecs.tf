resource "aws_ecs_cluster" "main" {
    name = "cb-cluster"
}

locals {
    vars = {
        app_image           = var.app_image
        app_port            = var.app_port
        fargate_cpu         = var.fargate_cpu
        fargate_memory      = var.fargate_memory
        aws_region          = var.aws_region
        secret_manager_name = var.secret_manager_name
    }
    template = templatefile("./templates/ecs/cb_app.json.tpl", local.vars)
}

resource "aws_ecs_task_definition" "app" {
    family                   = "cb-app-task"
    execution_role_arn       = aws_iam_role.ecs_task_execution_role.arn
    network_mode             = "awsvpc"
    requires_compatibilities = ["FARGATE"]
    cpu                      = var.fargate_cpu
    memory                   = var.fargate_memory
    container_definitions    = local.template
}

resource "aws_ecs_service" "main" {
    name            = "cb-service"
    cluster         = aws_ecs_cluster.main.id
    task_definition = aws_ecs_task_definition.app.arn
    desired_count   = var.app_count
    launch_type     = "FARGATE"

    network_configuration {
        security_groups  = [aws_security_group.public_sg_one.id]
        subnets          = aws_subnet.public_subnet_one.*.id
        assign_public_ip = true
    }

    depends_on = [aws_iam_role_policy_attachment.ecs_task_execution_role_policy_attachment, aws_iam_role_policy_attachment.ecs_get_secret_role_policy_attachment]
}