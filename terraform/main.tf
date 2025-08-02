provider "aws" {
  region = "ap-southeast-1"  
}

variable "aws_region" {
  default = "ap-southeast-1"
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
    depends_on = [  module.vpc]
  
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
    depends_on = [ module.security, module.vpc]
}
module "ec2-private" {
    source = "./modules/ec2-private"
    ami = var.ami
    security_group_id = module.security.private_sg_id
    aws_key_pair_bastion_key_id = var.aws_key_pair_aws-singapore-keypair
    instance_type = var.instance_type
    subnet_id = module.vpc.private_subnets[1]
    depends_on = [ module.security, module.vpc] 
}
module "alb" {
    source = "./modules/alb"
    vpc_id = module.vpc.vpc_id
    subnet_id = [module.vpc.public_subnets[0], module.vpc.public_subnets[1]]
    public_subnets = module.vpc.public_subnets
    alb_sg_id = module.security.alb_sg_id
    target_group_arn = module.alb.target_group_arn
    depends_on = [ module.security, module.vpc]
}
module "ecs" {
    source = "./modules/ecs"
    vpc_id = module.vpc.vpc_id
    private_subnets = [module.vpc.private_subnets[0], module.vpc.private_subnets[1]]
    target_group_arn = module.alb.target_group_arn
    security_group_id = module.security.ecs_security_group_id
    depends_on = [ module.security, module.vpc, module.alb ]
}

# Build and push Docker image after ECR is created
resource "null_resource" "docker_build_push" {
  depends_on = [module.ecs]

  provisioner "local-exec" {
    working_dir = "${path.root}/../web"
    command = <<-EOT
      aws ecr get-login-password --region ap-southeast-1 | docker login --username AWS --password-stdin ${module.ecs.ecr_repository_url}
      docker build -t simple-web-app:latest .
      docker tag simple-web-app:latest ${module.ecs.ecr_repository_url}:latest
      docker push ${module.ecs.ecr_repository_url}:latest
    EOT
  }

  triggers = {
    dockerfile_hash = filemd5("${path.root}/../web/Dockerfile")
    always_run = timestamp()
  }
}