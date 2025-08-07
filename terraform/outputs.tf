output "alb_dns_name" {
  description = "DNS name of the Application Load Balancer"
  value       = module.alb.alb_dns_name
}

output "domain_name" {
  description = "Domain name (if configured)"
  value       = var.domain_name
}

output "certificate_arn" {
  description = "ARN of the SSL certificate (if created)"
  value       = var.domain_name != null ? module.acm[0].certificate_arn : null
}

output "name_servers" {
  description = "Name servers for the hosted zone (if created)"
  value       = var.domain_name != null ? module.route53[0].name_servers : null
}