output "bastion_host_sg_id" {
  description = "ID of the bastion host security group"
  value       = aws_security_group.bastion-host-sg.id
}
output "alb_sg_id" {
  description = "ID of the ALB security group"
  value       = aws_security_group.alb-sg.id
}
output "private_sg_id" {
  description = "ID of the private security group"
  value       = aws_security_group.private-sg.id
}
output "ecs_security_group_id" {
  description = "ID of the ECS security group"
  value       = aws_security_group.ecs-cluster-sg.id
  
}