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

# Variable for the instance
variable "ami" {
  description = "AMI ID for the bastion host"
  type        = string
}
variable "instance_type" {
  description = "Instance type for the bastion host"
  type        = string
}
variable "aws_key_pair_aws-singapore-keypair" {
  description = "ID of the bastion key pair"
  type        = string
}