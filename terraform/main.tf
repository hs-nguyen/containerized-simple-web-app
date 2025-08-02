provider "aws" {
  region = "ap-southeast-1"  
}



module "vpc" {
    source = "./modules/vpc"
    azs = var.azs
    cidr = var.cidr
    name = var.name
    private_subnets = var.private_subnets
    public_subnets = var.public_subnets
}
module "security" {
    source = "./modules/security"
    vpc_id = module.vpc.vpc_id
  
}
module "keypair" {
    source = "./modules/keypair"
}
module "bastion_host" {
    source = "./modules/bastion"
    ami = var.ami
    security_group_id = module.security.bastion_host_sg_id
    aws_key_pair_bastion_key_id = var.aws_key_pair_aws-singapore-keypair
    instance_type = var.instance_type
    subnet_id = module.vpc.public_subnets[1]
}
module "ec2-private" {
    source = "./modules/ec2-private"
    ami = var.ami
    security_group_id = module.security.private_sg_id
    aws_key_pair_bastion_key_id = var.aws_key_pair_aws-singapore-keypair
    instance_type = var.instance_type
    subnet_id = module.vpc.private_subnets[1]
}