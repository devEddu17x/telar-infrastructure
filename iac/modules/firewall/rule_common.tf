resource "aws_wafv2_web_acl_rule" "common_rule_set" {
  name        = "aws-managed-common-rule-set"
  priority    = 1
  web_acl_arn = aws_wafv2_web_acl.main.arn

  override_action {
    none {}
  }

  statement {
    managed_rule_group_statement {
      name        = "AWSManagedRulesCommonRuleSet"
      vendor_name = "AWS"
    }
  }

  visibility_config {
    cloudwatch_metrics_enabled = var.cloudwatch_metrics_enabled
    metric_name                = "${var.name_prefix}-common-rule-set"
    sampled_requests_enabled   = var.sampled_requests_enabled
  }
}
