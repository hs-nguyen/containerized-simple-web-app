variable "security_group_id" {
  description = "ID of the security group for the bastion host"
  type        = string
}
variable "ami" {
  description = "AMI ID for the bastion host"
  type        = string
}
variable "instance_type" {
  description = "Instance type for the bastion host"
  type        = string
}
variable "aws_key_pair_bastion_key_id" {
  description = "ID of the bastion key pair"
  type        = string
}
variable "subnet_id" {
  description = "ID of the subnet where the bastion host will be launched"
  type        = string 
}
variable "environment" {
  description = "Environment for the bastion host (e.g., dev, prod)"
  type        = string
  default     = "dev"
  
}