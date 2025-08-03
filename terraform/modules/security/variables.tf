variable "vpc_id" {
  description = "ID of the VPC"
  type        = string
}
variable "allowed_ssh_cidr" {
  description = "CIDR block allowed for SSH access to the bastion host"
  type        = string
  
}