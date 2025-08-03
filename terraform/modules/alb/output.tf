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
  value       = aws_lb_target_group.simple-web-app-tg.arn
}

output "aws_lb_listener_arn" {
  description = "ARN of the ALB HTTP Listener"
  value       = aws_lb_listener.http_listener.arn
}

output "aws_lb_https_listener_arn" {
  description = "ARN of the ALB HTTPS Listener"
  value       = var.certificate_arn != null ? aws_lb_listener.https_listener[0].arn : null
}
output "alb_zone_id" {
  description = "Zone ID of the Application Load Balancer"
  value       = aws_lb.simple-web-app-alb.zone_id
}