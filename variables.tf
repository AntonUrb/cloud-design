variable "aws_region" {
  description = "Region"
  type        = string
  default     = "eu-north-1"
}

variable "cluster_name" {
  default = "app-cluster"
}

variable "azs" {
 type        = list(string)
 description = "Availability Zones"
 default     = ["eu-north-1a", "eu-north-1b"]
}