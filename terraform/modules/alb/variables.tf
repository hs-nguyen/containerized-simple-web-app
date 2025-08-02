variable "vpc_id" {
  description = "ID of the VPC where ALB will be created"
  type        = string
}

variable "subnet_id" {
  description = "Subnet ID for ALB placement"
  type        = list(string)
}

variable "public_subnets" {
  description = "List of public subnet IDs for ALB"
  type        = list(string)
}

variable "alb_sg_id" {
  description = "Security group ID for the ALB"
}

variable "target_group_arn" {
  description = "ARN of the target group"
  type        = string
}
