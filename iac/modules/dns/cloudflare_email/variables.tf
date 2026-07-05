variable "zone_id" {
  description = "Cloudflare zone ID"
  type        = string
}

variable "domain" {
  description = "Domain configured for email sending"
  type        = string
}

variable "ses_verification_token" {
  description = "SES domain verification token"
  type        = string
}

variable "ses_dkim_tokens" {
  description = "SES DKIM tokens"
  type        = list(string)
}

variable "mail_from_domain" {
  description = "SES MAIL FROM domain"
  type        = string
}

variable "aws_region" {
  description = "AWS region where SES is configured"
  type        = string
}

variable "dmarc_report_email" {
  description = "Email address that receives DMARC aggregate reports"
  type        = string
  default     = null
}

variable "manage_domain_spf" {
  description = "Manage SPF record at the root email domain"
  type        = bool
  default     = false
}

variable "manage_dmarc" {
  description = "Manage DMARC record at the root email domain"
  type        = bool
  default     = false
}
