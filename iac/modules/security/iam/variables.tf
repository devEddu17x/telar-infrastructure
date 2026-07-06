variable "name_prefix" {
  description = "Project-environment prefix used to name all IAM resources"
  type        = string
}

variable "ecs_execution_secrets_manager_arns" {
  description = "List of Secrets Manager secret ARNs the ECS Execution Role is allowed to read at container startup (injected as env vars / secrets in the task definition)"
  type        = list(string)
  default     = []

  validation {
    condition     = alltrue([for arn in var.ecs_execution_secrets_manager_arns : arn != "*"])
    error_message = "Provide explicit Secrets Manager ARNs for the ECS Execution Role; \"*\" is not allowed."
  }
}

variable "ssm_parameter_arns" {
  description = "List of SSM Parameter Store parameter ARNs the ECS Execution Role is allowed to read at container startup"
  type        = list(string)

  validation {
    condition     = length(var.ssm_parameter_arns) > 0 && alltrue([for arn in var.ssm_parameter_arns : arn != "*"])
    error_message = "Provide explicit SSM Parameter ARNs; \"*\" is not allowed."
  }
}

variable "s3_bucket_arns" {
  description = "List of S3 bucket ARNs the ECS Task Role is allowed to read from and write to"
  type        = list(string)

  validation {
    condition     = length(var.s3_bucket_arns) > 0 && alltrue([for arn in var.s3_bucket_arns : arn != "*"])
    error_message = "Provide explicit S3 bucket ARNs; \"*\" is not allowed."
  }
}

variable "cognito_user_pool_arn" {
  description = "ARN of the Cognito User Pool the ECS Task Role and Lambda are allowed to administer"
  type        = string

  validation {
    condition     = var.cognito_user_pool_arn != "*"
    error_message = "Provide an explicit Cognito User Pool ARN; \"*\" is not allowed."
  }
}

variable "lambda_pre_signup_secrets_manager_arns" {
  description = "List of Secrets Manager secret ARNs the Pre Sign-up Lambda is allowed to read (scoped to the shared secret it needs to validate the registration token)"
  type        = list(string)

  validation {
    condition     = length(var.lambda_pre_signup_secrets_manager_arns) > 0 && alltrue([for arn in var.lambda_pre_signup_secrets_manager_arns : arn != "*"])
    error_message = "Provide explicit Secrets Manager ARNs for the Lambda Pre Sign-up Role; \"*\" is not allowed."
  }
}
