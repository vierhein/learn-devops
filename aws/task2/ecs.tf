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
        secrets_arn         = local.transformed_secret_settings
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
    desired_count   = var.app_desired
    launch_type     = "FARGATE"

    network_configuration {
        security_groups  = [aws_security_group.public_sg_one.id]
        subnets          = aws_subnet.public_subnet.*.id
        assign_public_ip = true
    }

    load_balancer {
        target_group_arn = aws_alb_target_group.app.id
        container_name   = "cb-app"
        container_port   = var.app_port
    }

    depends_on = [aws_alb_listener.front_end, aws_iam_role_policy_attachment.policy_secretmanager_read_role-attach, aws_iam_role_policy_attachment.policy_task_execution_role-attach]
}