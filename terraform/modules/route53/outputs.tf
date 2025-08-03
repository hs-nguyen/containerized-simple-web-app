output "hosted_zone_id" {
  description = "ID of the hosted zone"
  value       = local.zone_id
}

output "name_servers" {
  description = "Name servers for the hosted zone"
  value       = var.create_hosted_zone ? aws_route53_zone.main[0].name_servers : null
}

output "domain_name" {
  description = "Domain name"
  value       = var.domain_name
}