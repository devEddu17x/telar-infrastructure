output "web_acl_arn" {
  description = "ARN of the WAFv2 Web ACL."
  value       = aws_wafv2_web_acl.main.arn
}

output "web_acl_id" {
  description = "ID of the WAFv2 Web ACL"
  value       = aws_wafv2_web_acl.main.id
}

output "web_acl_name" {
  description = "Name of the WAFv2 Web ACL"
  value       = aws_wafv2_web_acl.main.name
}

output "web_acl_capacity" {
  description = "Web ACL Capacity Units (WCU) consumed by the configured rules"
  value       = aws_wafv2_web_acl.main.capacity
}
