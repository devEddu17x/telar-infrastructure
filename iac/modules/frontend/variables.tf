variable "name_prefix" {
  description = "Prefix for naming all resources in this module"
  type        = string
}

variable "repository_url" {
  description = "HTTPS URL of the GitHub/GitLab repository containing the Next.js frontend source code"
  type        = string
}

variable "github_access_token" {
  description = "Personal Access Token (classic) with repo and admin:repo_hook scopes for the GitHub repository"
  type        = string
  sensitive   = true
}

variable "branch" {
  description = "Git branch to deploy (e.g. main, dev)" 
  type        = string
  default     = "develop"
}

variable "framework" {
  description = "Framework used for the frontend application"
  type        = string
  default     = "Next.js - SSG"
}

variable "branch_stage" {
  description = "Amplify stage for the deployed branch (DEVELOPMENT, BETA, PRODUCTION)"
  type        = string
  default     = "PRODUCTION"

  validation {
    condition     = contains(["DEVELOPMENT", "QA", "PRODUCTION"], var.branch_stage)
    error_message = "branch_stage must be DEVELOPMENT, BETA or PRODUCTION"
  }
}

variable "node_version" {
  description = "Node.js version to use in the Amplify build environment"
  type        = string
  default     = "20"
}

variable "domain_name" {
  description = "Custom domain managed by Route 53 to associate with the Amplify app (e.g. example.com). Leave empty to skip domain association."
  type        = string
  default     = ""
}

variable "web_acl_arn" {
  description = "ARN of the WAFv2 Web ACL (scope CLOUDFRONT) to associate with the Amplify distribution"
  type        = string
  default     = ""
}

variable "cognito_user_pool_id" {
  description = "Cognito User Pool ID to expose to the Next.js app as an environment variable"
  type        = string
}

variable "cognito_user_pool_endpoint" {
  description = "Cognito User Pool endpoint (issuer URL) to expose to the Next.js app"
  type        = string
}

variable "cognito_client_id" {
  description = "Cognito App Client ID to expose to the Next.js app as an environment variable"
  type        = string
}

variable "api_base_url" {
  description = "Base URL of the backend API to expose to the Next.js app (e.g. https://api.example.com)"
  type        = string
  default     = ""
}

variable "tags" {
  description = "Tags to apply to all resources in this module"
  type        = map(string)
  default     = {}
}
