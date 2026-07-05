variable "name_prefix" {
  description = "Project-environment prefix for resources"
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

variable "ses_identity_arns" {
  description = "SES identity ARNs the role can send from"
  type        = list(string)
}

variable "tags" {
  description = "Common tags applied to IAM resources"
  type        = map(string)
  default     = {}
}
