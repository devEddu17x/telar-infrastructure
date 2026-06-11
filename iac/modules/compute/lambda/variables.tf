variable "function_name" {
  description = "Name of the Lambda function"
  type        = string
}

variable "filename" {
  description = "Path to the deployment zip file"
  type        = string
}

variable "source_code_hash" {
  description = "Base64-encoded SHA256 hash of the deployment package"
  type        = string
}

variable "handler" {
  description = "Function entrypoint (file.exportedFunction)"
  type        = string
  default     = "index.handler"
}

variable "runtime" {
  description = "Lambda runtime"
  type        = string
  default     = "nodejs22.x"
}

variable "role_arn" {
  description = "ARN of the IAM role to attach to the Lambda function"
  type        = string
}

variable "environment_variables" {
  description = "Environment variables to inject into the Lambda function"
  type        = map(string)
  default     = {}
  sensitive   = true
}

variable "tags" {
  description = "Common tags for this module"
  type        = map(string)
  default     = {}
}
variable "cognito_user_pool_arn" {
  description = "ARN of the Cognito User Pool allowed to invoke this Lambda"
  type        = string
}
