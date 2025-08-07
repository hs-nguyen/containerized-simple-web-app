module "vpc" {
  source  = "terraform-aws-modules/vpc/aws"
  version = "5.1.0"

  name = var.name
  cidr = var.cidr

  azs             =  var.azs
  private_subnets = var.private_subnets
  public_subnets  = var.public_subnets

  enable_nat_gateway = true
  single_nat_gateway = true
  one_nat_gateway_per_az = false
  enable_vpn_gateway = false

  tags = {
    Terraform = "true"
    Environment = var.environment
  }
}