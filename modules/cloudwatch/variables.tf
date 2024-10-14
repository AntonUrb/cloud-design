variable "aws_region" {
  description = "Region"
  type        = string
  default     = "eu-north-1"
}

variable "alarm_threshold" {
  type    = number
  default = 5
}


variable "namespace" {
  type    = string
  default = "AWS/ApplicationELB"  # For ALB
}

variable "eks_cluster_name" {
  type = string
}