output "app_id" {
  description = "Unique ID of the Amplify app"
  value       = aws_amplify_app.frontend.id
}

output "app_arn" {
  description = "ARN of the Amplify app (used for WAF association)"
  value       = aws_amplify_app.frontend.arn
}

output "app_name" {
  description = "Name of the Amplify app"
  value       = aws_amplify_app.frontend.name
}

output "default_domain" {
  description = "Default Amplify domain for the app (*.amplifyapp.com)"
  value       = aws_amplify_app.frontend.default_domain
}

output "branch_url" {
  description = "Public HTTPS URL for the deployed branch"
  value       = "https://${aws_amplify_branch.main.branch_name}.${aws_amplify_app.frontend.default_domain}"
}

output "custom_domain_url" {
  description = "Custom domain URL (only available when domain_name is set)"
  value       = var.domain_name != "" ? "https://${var.domain_name}" : null
}

output "domain_association_arn" {
  description = "ARN of the Amplify domain association (only available when domain_name is set)"
  value       = var.domain_name != "" ? aws_amplify_domain_association.frontend[0].arn : null
}

output "webhook_url" {
  description = "Amplify App default domain (root) — use this to build the webhook URL in CI/CD"
  value       = aws_amplify_app.frontend.default_domain
}
