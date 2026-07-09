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
  description = "ARN of the Lambda function to invoke as the Cognito Pre Sign-up trigger"
  type        = string
}

