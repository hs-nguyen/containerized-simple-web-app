variable "aws_region" {
  description = "AWS region for resources"
  type        = string
  default     = "ap-southeast-1"
}

variable "azs" {
  description = "List of availability zones for the VPC"
  type        = list(string)
}

variable "public_subnets" {
  description = "List of public subnet CIDRs"
  type        = list(string)
}

variable "private_subnets" {
  description = "List of private subnet CIDRs"
  type        = list(string)
}

variable "cidr" {
  description = "CIDR block for the VPC"
  type        = string
}

variable "name" {
  description = "Name of the VPC"
  type        = string
  default     = "simple-web-app-vpc"
}

variable "ami" {
  description = "AMI ID for EC2 instances"
  type        = string
}

variable "instance_type" {
  description = "Instance type for EC2 instances"
  type        = string
}

variable "key_pair_name" {
  description = "Name of the EC2 key pair for instances"
  type        = string
}

variable "environment" {
  description = "Environment name"
  type        = string
  default     = "dev"
}

variable "allowed_ssh_cidr" {
  description = "CIDR block allowed for SSH access to bastion host"
  type        = string
  default     = "0.0.0.0/32"  # Must be changed to your IP
}

variable "domain_name" {
  description = "Domain name for the application (optional)"
  type        = string
  default     = null
}

variable "create_hosted_zone" {
  description = "Whether to create a new Route53 hosted zone"
  type        = bool
  default     = false
}