output "domain" {
  description = "Verified SES domain"
  value       = aws_ses_domain_identity.this.domain
}

output "domain_identity_arn" {
  description = "ARN of the SES domain identity"
  value       = aws_ses_domain_identity.this.arn
}

output "verification_token" {
  description = "Token used to verify the SES domain"
  value       = aws_ses_domain_identity.this.verification_token
}

output "dkim_tokens" {
  description = "Tokens used to configure DKIM records"
  value       = aws_ses_domain_dkim.this.dkim_tokens
}

output "mail_from_domain" {
  description = "MAIL FROM domain for SES"
  value       = aws_ses_domain_mail_from.this.mail_from_domain
}
