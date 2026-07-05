resource "cloudflare_dns_record" "ses_verification" {
  zone_id = var.zone_id
  name    = "_amazonses.${var.domain}"
  type    = "TXT"
  content = var.ses_verification_token
  ttl     = 1
}

resource "cloudflare_dns_record" "ses_dkim" {
  count = 3

  zone_id = var.zone_id
  name    = "${var.ses_dkim_tokens[count.index]}._domainkey.${var.domain}"
  type    = "CNAME"
  content = "${var.ses_dkim_tokens[count.index]}.dkim.amazonses.com"
  ttl     = 1
  proxied = false
}

resource "cloudflare_dns_record" "mail_from_mx" {
  zone_id  = var.zone_id
  name     = var.mail_from_domain
  type     = "MX"
  content  = "feedback-smtp.${var.aws_region}.amazonses.com"
  priority = 10
  ttl      = 1
}

resource "cloudflare_dns_record" "mail_from_spf" {
  zone_id = var.zone_id
  name    = var.mail_from_domain
  type    = "TXT"
  content = "v=spf1 include:amazonses.com ~all"
  ttl     = 1
}

resource "cloudflare_dns_record" "domain_spf" {
  count = var.manage_domain_spf ? 1 : 0

  zone_id = var.zone_id
  name    = var.domain
  type    = "TXT"
  content = "v=spf1 include:zohomail.com include:amazonses.com ~all"
  ttl     = 1
}

resource "cloudflare_dns_record" "dmarc" {
  count = var.manage_dmarc ? 1 : 0

  zone_id = var.zone_id
  name    = "_dmarc.${var.domain}"
  type    = "TXT"
  content = var.dmarc_report_email != null ? "v=DMARC1; p=none; rua=mailto:${var.dmarc_report_email}" : "v=DMARC1; p=none"
  ttl     = 1
}
