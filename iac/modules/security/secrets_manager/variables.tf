variable "secret_name" {
  description = "Full name of the secret in Secrets Manager (e.g. telar-saas/dev/db-credentials)"
  type        = string
}

variable "description" {
  description = "Human-readable description of the secret"
  type        = string
  default     = null
}

variable "kms_key_id" {
  description = "ARN or ID of the KMS key used to encrypt the secret. Defaults to the AWS-managed key if null"
  type        = string
  default     = null
}

variable "recovery_window_in_days" {
  description = "Number of days that Secrets Manager waits before permanently deleting the secret (0 to disable recovery window)"
  type        = number
  default     = 30

  validation {
    condition     = var.recovery_window_in_days == 0 || (var.recovery_window_in_days >= 7 && var.recovery_window_in_days <= 30)
    error_message = "recovery_window_in_days must be 0 (force delete) or between 7 and 30."
  }
}

variable "secret_string" {
  description = "Initial secret value as a JSON string. Managed externally after first apply (lifecycle ignore_changes)"
  type        = string
  sensitive   = true
  default     = "{}"
}

variable "allowed_principal_arns" {
  description = "List of IAM principal ARNs allowed to call GetSecretValue via resource policy (e.g. ECS execution role, Lambda role). Leave empty to skip resource policy."
  type        = list(string)
  default     = []

  validation {
    condition     = alltrue([for arn in var.allowed_principal_arns : arn != "*"])
    error_message = "Provide explicit IAM principal ARNs; \"*\" is not allowed."
  }
}

variable "tags" {
  description = "Tags to apply to all Secrets Manager resources"
  type        = map(string)
  default     = {}
}
