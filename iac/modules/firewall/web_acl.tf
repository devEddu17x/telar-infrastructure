resource "aws_wafv2_web_acl" "main" {
  name        = "${var.name_prefix}-web-acl"
  description = "WAFv2 Web ACL for ${var.name_prefix}"
  scope       = var.scope

  default_action {
    allow {}
  }

  visibility_config {
    cloudwatch_metrics_enabled = var.cloudwatch_metrics_enabled
    metric_name                = "${var.name_prefix}-web-acl"
    sampled_requests_enabled   = var.sampled_requests_enabled
  }

  lifecycle {
    ignore_changes = [rule]
  }

  tags = var.tags
}
