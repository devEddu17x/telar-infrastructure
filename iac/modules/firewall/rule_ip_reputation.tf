
resource "aws_wafv2_web_acl_rule" "ip_reputation" {
  name        = "aws-managed-ip-reputation"
  priority    = 3
  web_acl_arn = aws_wafv2_web_acl.main.arn

  override_action {
    none {}
  }

  statement {
    managed_rule_group_statement {
      name        = "AWSManagedRulesAmazonIpReputationList"
      vendor_name = "AWS"
    }
  }

  visibility_config {
    cloudwatch_metrics_enabled = var.cloudwatch_metrics_enabled
    metric_name                = "${var.name_prefix}-ip-reputation"
    sampled_requests_enabled   = var.sampled_requests_enabled
  }
}
