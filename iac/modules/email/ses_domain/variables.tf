variable "domain" {
  description = "Domain to verify in SES"
  type        = string
}

variable "mail_from_subdomain" {
  description = "Subdomain used for SES MAIL FROM"
  type        = string
  default     = "mail"
}
