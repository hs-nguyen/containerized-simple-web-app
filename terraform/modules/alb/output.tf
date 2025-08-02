output "alb_dns_name" {
  description = "DNS name of the Application Load Balancer"
  value       = aws_lb.simple-web-app-alb.dns_name
}
output "alb_arn" {
  description = "ARN of the Application Load Balancer"
  value       = aws_lb.simple-web-app-alb.arn
}

output "target_group_arn" {
  description = "ARN of the Target Group"
  value       = aws_lb_target_group.simle-web-app-tg.arn
}

output "aws_lb_listener_arn" {
  description = "ARN of the ALB Listener"
  value       = aws_lb_listener.simple-web-app-listener.arn
}