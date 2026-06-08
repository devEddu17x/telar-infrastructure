variable "name_prefix" {
  description = "Project-environment prefix used to name all IAM resources (e.g. 'telar-saas-dev')"
  type        = string
}

variable "secrets_manager_arns" {
  description = "List of Secrets Manager secret ARNs the ECS Execution Role is allowed to read at container startup"
  type        = list(string)
  default     = ["*"]
}

variable "ssm_parameter_arns" {
  description = "List of SSM Parameter Store parameter ARNs the ECS Execution Role is allowed to read at container startup"
  type        = list(string)
  default     = ["*"]
}

variable "s3_bucket_arns" {
  description = "List of S3 bucket ARNs the ECS Task Role is allowed to read from and write to"
  type        = list(string)
  default     = ["*"]
}

variable "cognito_user_pool_arn" {
  description = "ARN of the Cognito User Pool the ECS Task Role and Lambda are allowed to administer"
  type        = string
  default     = "*"
}
