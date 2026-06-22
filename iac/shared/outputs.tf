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
