
variable "aws_region" {
  description = "AWS region where bootstrap resources are provisioned"
  type        = string
}

variable "aws_profile" {
  description = "AWS config profile name"
  type        = string
}

variable "project_name" {
  description = "Project identifier used in naming and tagging"
  type        = string
}

variable "environment" {
  description = "Environment identifier for bootstrap resources"
  type        = string
  default     = "dev"
}
