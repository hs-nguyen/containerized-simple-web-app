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
  default     = "d-vpc-01"
}

variable "environment" {
  description = "Environment name"
  type        = string
  default     = "dev"
}