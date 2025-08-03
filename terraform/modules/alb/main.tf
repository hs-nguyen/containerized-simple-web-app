
#Create Target Group
resource "aws_lb_target_group" "simple-web-app-tg" {
  name        = "simple-web-app-tg"
  port        = 80
  target_type = "ip"
  protocol    = "HTTP"
  vpc_id      = var.vpc_id
  
  health_check {
    enabled             = true
    healthy_threshold   = 3
    unhealthy_threshold = 3
    timeout             = 5
    interval            = 30
    path                = "/"
    matcher             = "200"
    port                = "traffic-port"
    protocol            = "HTTP"
  }
  
  tags = {
    Name        = "simple-web-app-tg"
  }
}
#Create Application Load Balancer
resource "aws_lb" "simple-web-app-alb" {
  name               = "simple-web-app-alb"
  internal           = false
  load_balancer_type = "application"
  security_groups    = [var.alb_sg_id]
  subnets            = var.public_subnets
  depends_on = [ aws_lb_target_group.simple-web-app-tg ]

  enable_deletion_protection = false
  drop_invalid_header_fields = true

  tags = {
    Name        = "simple-web-app-alb"
  }
}
#Create HTTP Listener
resource "aws_lb_listener" "http_listener" {
  load_balancer_arn = aws_lb.simple-web-app-alb.arn
  port              = "80"
  protocol          = "HTTP"

  default_action {
    type = var.certificate_arn != null ? "redirect" : "forward"

    dynamic "redirect" {
      for_each = var.certificate_arn != null ? [1] : []
      content {
        port        = "443"
        protocol    = "HTTPS"
        status_code = "HTTP_301"
      }
    }

    dynamic "forward" {
      for_each = var.certificate_arn == null ? [1] : []
      content {
        target_group {
          arn = aws_lb_target_group.simple-web-app-tg.arn
        }
      }
    }
  }

  tags = {
    Name        = "simple-web-app-http-listener"
  }
  depends_on = [ aws_lb.simple-web-app-alb ]
}

#Create HTTPS Listener (only when certificate exists)
resource "aws_lb_listener" "https_listener" {
  count             = var.certificate_arn != null ? 1 : 0
  load_balancer_arn = aws_lb.simple-web-app-alb.arn
  port              = "443"
  protocol          = "HTTPS"
  ssl_policy        = "ELBSecurityPolicy-TLS-1-2-2017-01"
  certificate_arn   = var.certificate_arn

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.simple-web-app-tg.arn
  }

  tags = {
    Name        = "simple-web-app-https-listener"
  }
  depends_on = [ aws_lb_listener.http_listener ]
}

