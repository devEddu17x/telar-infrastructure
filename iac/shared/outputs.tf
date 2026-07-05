output "github_oidc_provider_arn" {
  description = "ARN of the GitHub OIDC provider"
  value       = aws_iam_openid_connect_provider.github.arn
}

output "frontend_github_oidc_role_arn" {
  description = "ARN of the frontend deployment role"
  value       = module.frontend_github_oidc_role.role_arn
}

output "frontend_github_oidc_role_name" {
  description = "Name of the frontend deployment role"
  value       = module.frontend_github_oidc_role.role_name
}

output "backend_github_oidc_role_arn" {
  description = "ARN of the backend deployment role"
  value       = module.backend_github_oidc_role.role_arn
}

output "backend_github_oidc_role_name" {
  description = "Name of the backend deployment role"
  value       = module.backend_github_oidc_role.role_name
}

output "landing_github_oidc_role_arn" {
  description = "ARN of the landing page deployment role"
  value       = module.landing_github_oidc_role.role_arn
}

output "landing_github_oidc_role_name" {
  description = "Name of the landing page deployment role"
  value       = module.landing_github_oidc_role.role_name
}

output "iac_github_oidc_role_arn" {
  description = "ARN of the IAC GitHub Actions role"
  value       = module.iac_github_oidc_role.role_arn
}

output "iac_github_oidc_role_name" {
  description = "Name of the IAC GitHub Actions role"
  value       = module.iac_github_oidc_role.role_name
}

output "checkov_email_domain_identity_arn" {
  description = "ARN of the SES domain identity"
  value       = module.checkov_email.domain_identity_arn
}

output "checkov_email_domain" {
  description = "SES email domain"
  value       = aws_ses_domain_identity_verification.checkov_email.domain
}

output "checkov_email_mail_from_domain" {
  description = "SES MAIL FROM domain"
  value       = module.checkov_email.mail_from_domain
}
