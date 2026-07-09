variable "aws_region" {
  description = "AWS region where shared resources are provisioned"
  type        = string
  default     = "us-east-1"
}

variable "aws_profile" {
  description = "AWS shared config profile name"
  type        = string
  default     = null
}

variable "project_name" {
  description = "Project identifier used in naming and tagging"
  type        = string
}

variable "environment" {
  description = "Environment identifier for shared resources"
  type        = string
  default     = "shared"
}

variable "github_oidc_thumbprints" {
  description = "Thumbprints for the GitHub OIDC provider"
  type        = list(string)
  default     = ["6938fd4d98bab03faadb97b34396831e3780aea1"]
}

variable "frontend_github_repository" {
  description = "GitHub repository that deploys the frontend"
  type        = string
}

variable "frontend_github_branches" {
  description = "Git branches allowed to deploy the frontend"
  type        = list(string)
  default     = []
}

variable "frontend_github_environments" {
  description = "GitHub environments allowed to deploy the frontend"
  type        = list(string)
  default     = ["dev"]
}

variable "frontend_parameter_path" {
  description = "Frontend SSM parameter path under each environment prefix"
  type        = string
  default     = "frontend"
}

variable "frontend_bucket_suffixes" {
  description = "Frontend bucket suffixes the role can deploy to"
  type        = list(string)
  default     = ["system-frontend"]
}

variable "backend_github_repository" {
  description = "GitHub repository that deploys the backend"
  type        = string
}

variable "backend_github_branches" {
  description = "Git branches allowed to deploy the backend"
  type        = list(string)
  default     = []
}

variable "backend_github_environments" {
  description = "GitHub environments allowed to deploy the backend"
  type        = list(string)
  default     = ["dev"]
}

variable "backend_parameter_path" {
  description = "Backend deploy SSM parameter path under each environment prefix"
  type        = string
  default     = "backend/deploy"
}

variable "landing_github_repository" {
  description = "GitHub repository that deploys the landing page"
  type        = string
}

variable "landing_github_branches" {
  description = "Git branches allowed to deploy the landing page"
  type        = list(string)
  default     = []
}

variable "landing_github_environments" {
  description = "GitHub environments allowed to deploy the landing page"
  type        = list(string)
  default     = ["dev"]
}

variable "landing_parameter_path" {
  description = "Landing page SSM parameter path under each environment prefix"
  type        = string
  default     = "landing-page"
}

variable "cloudflare_api_token" {
  description = "Cloudflare API token used to manage DNS records"
  type        = string
  sensitive   = true
}

variable "cloudflare_zone_id" {
  description = "Cloudflare zone ID for the email domain"
  type        = string
}

variable "checkov_email_domain" {
  description = "Domain used to send Checkov report emails"
  type        = string
}

variable "checkov_email_mail_from_subdomain" {
  description = "Subdomain used as the SES MAIL FROM domain"
  type        = string
  default     = "ses"
}

variable "checkov_email_dmarc_report_email" {
  description = "Email address that receives DMARC aggregate reports"
  type        = string
  default     = null
}

variable "checkov_email_manage_domain_spf" {
  description = "Manage the root domain SPF record for SES"
  type        = bool
  default     = false
}

variable "checkov_email_manage_dmarc" {
  description = "Manage the root domain DMARC record"
  type        = bool
  default     = false
}

variable "checkov_email_from_addresses" {
  description = "Email addresses allowed to send Checkov reports"
  type        = list(string)
  default     = []
}

variable "iac_github_repository" {
  description = "GitHub repository allowed to send Checkov report emails"
  type        = string
  default     = "devEddu17x/telar-infrastructure"
}

variable "iac_github_branches" {
  description = "Git branches allowed to send Checkov report emails"
  type        = list(string)
  default     = ["develop", "qa", "prod"]
}

variable "iac_github_environments" {
  description = "GitHub environments allowed to send Checkov report emails"
  type        = list(string)
  default     = ["dev", "qa", "prod"]
}

variable "iac_github_allow_pull_requests" {
  description = "Allow pull request workflows to send Checkov report emails"
  type        = bool
  default     = true
}

variable "iac_deploy_github_repository" {
  description = "GitHub repository allowed to apply Terraform"
  type        = string
  default     = "devEddu17x/telar-infrastructure"
}

variable "iac_deploy_github_branches" {
  description = "Git branches allowed to apply Terraform"
  type        = list(string)
  default     = ["develop", "qa", "prod"]
}

variable "iac_deploy_github_environments" {
  description = "GitHub environments allowed to apply Terraform"
  type        = list(string)
  default     = ["dev", "qa", "prod"]
}

variable "iac_deploy_managed_policy_arns" {
  description = "Managed policies attached to the Terraform deploy role"
  type        = list(string)
  default     = ["arn:aws:iam::aws:policy/AdministratorAccess"]
}
