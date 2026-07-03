resource "aws_ses_email_identity" "emails" {
  for_each = toset(var.emails)
  email    = each.key
}

resource "aws_ses_domain_identity" "domain" {
  count  = var.domain != "" ? 1 : 0
  domain = var.domain
}