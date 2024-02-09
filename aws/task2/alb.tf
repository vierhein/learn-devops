resource "aws_alb" "main" {
    name        = "cb-load-balancer"
    subnets         = [aws_subnet.public_subnet_one.id, aws_subnet.public_subnet_two.id]
    security_groups = [aws_security_group.public_sg_one.id]
}

resource "aws_alb_target_group" "app" {
    name        = "cb-target-group"
    port        = 80
    protocol    = "HTTP"
    vpc_id      = aws_vpc.vpc_one.id
    target_type = "ip"

    health_check {
        healthy_threshold   = "2"
        interval            = "10"
        protocol            = "HTTP"
        matcher             = "200"
        timeout             = "3"
        path                = "/"
        unhealthy_threshold = "2"
    }
}

# Redirect all traffic from the ALB to the target group
resource "aws_alb_listener" "front_end" {
  load_balancer_arn = aws_alb.main.id
  port              = var.app_port
  protocol          = "HTTP"

  default_action {
    target_group_arn = aws_alb_target_group.app.id
    type             = "forward"
  }
}
