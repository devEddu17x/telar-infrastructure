variable "name_prefix" {
  description = "Prefix used for naming user pool and groups"
  type        = string
}
variable "app_email_subject" {
  description = "Subject for email verification messages"
  type        = string
  default     = "telar-saas"
}

variable "pre_signup_lambda_arn" {
  description = "ARN of the Lambda function to invoke before user sign up"
  type        = string
}
variable "mfa_configuration" {
  description = "MFA configuration for the user pool. Valid values: OFF, OPTIONAL, ON"
  type        = string
  default     = "OFF"

  validation {
    condition     = contains(["OFF", "OPTIONAL", "ON"], var.mfa_configuration)
    error_message = "mfa_configuration must be one of: OFF, OPTIONAL, ON."
  }
}