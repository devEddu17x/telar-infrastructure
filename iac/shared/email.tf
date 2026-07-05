resource "aws_ses_domain_identity_verification" "checkov_email" {
  domain = module.checkov_email.domain

  depends_on = [module.checkov_email_dns]
}
