output "email_service_arn" {
  description = "ARN of the IAM role for GitHub Actions to use SES"
  value       = aws_iam_role.github_actions_ses.arn
}

output "verified_emails" {
  description = "List of verified email identities"
  value       = [for k, v in aws_ses_email_identity.emails : v.email]
}

output "verified_domain" {
  description = "Verified domain identity"
  value       = var.domain != "" ? aws_ses_domain_identity.domain[0].domain : null
}
