output "ses_verification_record_id" {
  description = "Cloudflare record ID for SES verification"
  value       = cloudflare_dns_record.ses_verification.id
}

output "dkim_record_ids" {
  description = "Cloudflare record IDs for SES DKIM"
  value       = [for record in cloudflare_dns_record.ses_dkim : record.id]
}

output "mail_from_record_ids" {
  description = "Cloudflare record IDs for MAIL FROM"
  value = [
    cloudflare_dns_record.mail_from_mx.id,
    cloudflare_dns_record.mail_from_spf.id
  ]
}

output "policy_record_ids" {
  description = "Cloudflare record IDs for email policies"
  value = concat(
    [for record in cloudflare_dns_record.domain_spf : record.id],
    [for record in cloudflare_dns_record.dmarc : record.id]
  )
}
