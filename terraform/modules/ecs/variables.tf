variable "private_subnets" {
  description = "List of private subnet CIDRs"
  type        = list(string)
}

variable "target_group_arn" {
  description = "ARN of the target group for the ALB"
  type        = string
}

variable "vpc_id" {
  description = "ID of the VPC"
  type        = string
}

variable "security_group_id" {
  description = "ID of the security group to associate with the ALB"
  type        = string
}