variable "vpc_cidr" {
  description = "The CIDR block for the VPC"
  type        = string
  default = "10.0.0.0/16"
}

variable "env" {
  description = "The environment name (e.g., dev, stage, prod)"
  type        = string
  default = "stage"
}