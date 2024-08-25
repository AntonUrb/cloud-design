provider "aws" {
  region = var.aws_region
}

module "vpc" {
  source = "./modules/vpc"

  vpc_cidr        = var.vpc_cidr
  env             = var.env
  az              = var.az
  public_subnets  = var.public_subnets
  private_subnets = var.private_subnets
  eks_name        = var.eks_name
  eks_version     = var.eks_version
}

module "eks" {
  source = "./modules/eks"

  eks_name    = var.eks_name
  eks_version = var.eks_version
  env         = var.env

  subnet_id = {
    value = module.vpc.private_subnet_ids # Accessing the output from the VPC module
  }
}

terraform {
  backend "s3" {
    bucket         = "cloud-design"
    key            = "workspace/terraform.tfstate"
    region         = "eu-north-1"
    dynamodb_table = "terraform-state-lock"
    encrypt        = true
  }
}

