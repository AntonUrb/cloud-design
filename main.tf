provider "aws" {
  region = var.aws_region
}

module "vpc" {
  source = "./modules/vpc"

}

terraform {
  backend "local" {
    path          = "terraform.tfstate"
    workspace_dir = "workspace"
  }
}