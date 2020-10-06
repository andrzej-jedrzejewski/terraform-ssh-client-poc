module "vpc" {
  source     = "git::https://github.com/cloudposse/terraform-aws-vpc.git?ref=master"
  namespace  = var.namespace
  stage      = var.environment
  name       = "poc-vpc"
  cidr_block = "192.168.0.0/16"
}

locals {
  public_cidr_block  = cidrsubnet(module.vpc.vpc_cidr_block, 1, 0)
  private_cidr_block = cidrsubnet(module.vpc.vpc_cidr_block, 1, 1)
}

module "public_subnets" {
  source            = "git::https://github.com/cloudposse/terraform-aws-named-subnets.git?ref=master"
  namespace         = var.namespace
  stage             = var.environment
  name              = "bastion"
  subnet_names      = ["bastion1"]
  vpc_id            = module.vpc.vpc_id
  cidr_block        = local.public_cidr_block
  type              = "public"
  igw_id            = module.vpc.igw_id
  availability_zone = "eu-central-1a"
}

module "private_subnets" {
  source            = "git::https://github.com/cloudposse/terraform-aws-named-subnets.git?ref=master"
  namespace         = var.namespace
  stage             = var.environment
  name              = "backend"
  subnet_names      = var.backend_subnet_names
  vpc_id            = module.vpc.vpc_id
  cidr_block        = local.private_cidr_block
  type              = "private"
  availability_zone = "eu-central-1a"
  ngw_id            = module.public_subnets.ngw_id
}

