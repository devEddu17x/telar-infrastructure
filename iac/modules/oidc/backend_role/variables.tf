variable "name_prefix" {
  description = "Prefix for naming IAM resources"
  type        = string
}

variable "role_suffix" {
  description = "Suffix for the IAM role name"
  type        = string
}

variable "provider_arn" {
  description = "ARN of the GitHub OIDC provider"
  type        = string
}

variable "provider_url" {
  description = "Host name of the GitHub OIDC provider"
  type        = string
}

variable "repository" {
  description = "GitHub repository allowed to assume the role"
  type        = string
}

variable "branches" {
  description = "Git branches allowed to assume the role"
  type        = list(string)
  default     = []
}

variable "environments" {
  description = "GitHub environments allowed to assume the role"
  type        = list(string)
  default     = []
}

variable "ssm_parameter_arns" {
  description = "SSM parameter ARNs the role can read"
  type        = list(string)
}

variable "ecr_repository_arns" {
  description = "ECR repository ARNs the role can push to"
  type        = list(string)
}

variable "ecs_cluster_arns" {
  description = "ECS cluster ARNs the role can deploy to"
  type        = list(string)
}

variable "ecs_service_arns" {
  description = "ECS service ARNs the role can update"
  type        = list(string)
}

variable "ecs_task_definition_arns" {
  description = "ECS task definition ARNs the role can describe"
  type        = list(string)
}

variable "iam_role_arns" {
  description = "IAM role ARNs the deploy role can pass"
  type        = list(string)
}

variable "tags" {
  description = "Common tags applied to IAM resources"
  type        = map(string)
  default     = {}
}
