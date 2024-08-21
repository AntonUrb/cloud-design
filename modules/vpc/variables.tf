locals {
  env      = "staging"
  region   = "eu-north-1"
  zone1    = "eu-north-1a"
  zone2    = "eu-north-1b"
  eks_name = "cluster"
  version  = "1.30"
}

variable "vpc_cidr" {
  description = "The CIDR block for the VPC"
  type        = string
  default     = "10.0.0.0/16"
}

variable "env" {
  description = "The environment name (e.g., dev, stage, prod)"
  type        = string
  default     = "stage"
}

variable "all_traffic-cidr" {
  description = "The CIDR block for all traffic"
  type = string
  default     = "0.0.0.0/0"
}
