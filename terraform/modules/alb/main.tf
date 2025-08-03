
#Create Target Group
resource "aws_lb_target_group" "simple-web-app-tg" {
  name     = "simple-web-app-tg"
    port     = 80
    target_type = "ip"
    protocol = "HTTP"
    vpc_id   = var.vpc_id
    health_check {
        path                = "/"
        interval            = 30
        timeout             = 3
        healthy_threshold   = 3
        unhealthy_threshold = 3
    }
    tags = {
        Name        = "simple-web-app-tg"
        Environment = "dev"
    }
}
#Create Listerner forwarding to Target Group
resource "aws_lb_listener" "simple-web-app-listener" {
  load_balancer_arn = aws_lb.simple-web-app-alb.arn
  port              = 80
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.simple-web-app-tg.arn
  }

  tags = {
    Name        = "simple-web-app-listener"
    Environment = "dev"
  }
}
#Create Application Load Balancer
resource "aws_lb" "simple-web-app-alb" {
  name               = "simple-web-app-alb"
  internal           = false
  load_balancer_type = "application"
  security_groups    = [var.alb_sg_id]
  subnets            = var.public_subnets

  enable_deletion_protection = false
  drop_invalid_header_fields = true

  tags = {
    Name        = "simple-web-app-alb"
    Environment = "dev"
  }
}
