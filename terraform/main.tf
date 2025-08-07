provider "aws" {
  region = var.aws_region
}

module "vpc" {
  source          = "./modules/vpc"
  azs             = var.azs
  cidr            = var.cidr
  name            = var.name
  private_subnets = var.private_subnets
  public_subnets  = var.public_subnets
  environment     = var.environment
}

module "security" {
  source           = "./modules/security"
  vpc_id           = module.vpc.vpc_id
  allowed_ssh_cidr = var.allowed_ssh_cidr
  depends_on       = [module.vpc]
}

module "alb" {
  source         = "./modules/alb"
  vpc_id         = module.vpc.vpc_id
  subnet_ids     = [module.vpc.public_subnets[0], module.vpc.public_subnets[1]]
  public_subnets = module.vpc.public_subnets
  alb_sg_id      = module.security.alb_sg_id
  environment    = var.environment
  depends_on     = [module.security, module.vpc]
}

module "route53" {
  count              = var.domain_name != null ? 1 : 0
  source             = "./modules/route53"
  domain_name        = var.domain_name
  create_hosted_zone = var.create_hosted_zone
  alb_dns_name       = module.alb.alb_dns_name
  alb_zone_id        = module.alb.alb_zone_id
  environment        = var.environment
  depends_on         = [module.alb]
}

module "acm" {
  count          = var.domain_name != null ? 1 : 0
  source         = "./modules/acm"
  domain_name    = var.domain_name
  hosted_zone_id = module.route53[0].hosted_zone_id
  environment    = var.environment
  depends_on     = [module.route53]
}

# Create HTTPS listener when certificate is available
resource "aws_lb_listener" "https_listener" {
  count             = var.domain_name != null ? 1 : 0
  load_balancer_arn = module.alb.alb_arn
  port              = "443"
  protocol          = "HTTPS"
  ssl_policy        = "ELBSecurityPolicy-TLS-1-2-2017-01"
  certificate_arn   = module.acm[0].certificate_arn

  default_action {
    type             = "forward"
    target_group_arn = module.alb.target_group_arn
  }

  tags = {
    Name        = "simple-web-app-https-listener"
    Environment = var.environment
  }

  depends_on = [module.acm, module.alb]
}

module "ecs" {
  source            = "./modules/ecs"
  vpc_id            = module.vpc.vpc_id
  private_subnets   = [module.vpc.private_subnets[0], module.vpc.private_subnets[1]]
  target_group_arn  = module.alb.target_group_arn
  security_group_id = module.security.ecs_security_group_id
  aws_region        = var.aws_region
  environment       = var.environment
  depends_on        = [module.security, module.vpc, module.alb]
}