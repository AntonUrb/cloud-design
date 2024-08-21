provider "aws" {
  region = var.aws_region
}

module "vpc" {
  source = "./modules/vpc"

  env             = var.env
  vpc_cidr        = var.vpc_cidr
  az              = var.az
  public_subnets  = var.public_subnets
  private_subnets = var.private_subnets
  eks_name        = var.eks_name
  eks_version     = var.eks_version
}

terraform {
  backend "local" {
    path          = "terraform.tfstate"
    workspace_dir = "workspace"
  }
}
