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
  description = "Environment identifier: dev, qa, prod"
  type        = string
}

variable "state_lock_table_name" {
  description = "DynamoDB table name used for Terraform state locking"
  type        = string
}
