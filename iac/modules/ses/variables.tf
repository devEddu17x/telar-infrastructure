variable "name_prefix" {
  description = "Prefix for naming resources"
  type        = string
}

variable "emails" {
  description = "List of email addresses to verify in SES"
  type        = list(string)
  default     = []
}

variable "domain" {
  description = "Domain to verify in SES"
  type        = string
  default     = ""
}

variable "github_oidc_provider_arn" {
  description = "ARN of the GitHub OIDC provider"
  type        = string
}

variable "github_oidc_provider_url" {
  description = "Host name of the GitHub OIDC provider"
  type        = string
}

variable "github_repository" {
  description = "GitHub repository allowed to assume the SES role"
  type        = string
}

variable "github_branches" {
  description = "Git branches allowed to assume the SES role"
  type        = list(string)
  default     = []
}

variable "github_environments" {
  description = "GitHub environments allowed to assume the SES role"
  type        = list(string)
  default     = []
}

variable "tags" {
  description = "Common tags for resources"
  type        = map(string)
  default     = {}
}
