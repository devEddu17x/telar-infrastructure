resource "aws_wafv2_web_acl_rule" "known_bad_inputs" {
  name        = "aws-managed-known-bad-inputs"
  priority    = 2
  web_acl_arn = aws_wafv2_web_acl.main.arn

  override_action {
    none {}
  }

  statement {
    managed_rule_group_statement {
      name        = "AWSManagedRulesKnownBadInputsRuleSet"
      vendor_name = "AWS"
    }
  }

  visibility_config {
    cloudwatch_metrics_enabled = var.cloudwatch_metrics_enabled
    metric_name                = "${var.name_prefix}-known-bad-inputs"
    sampled_requests_enabled   = var.sampled_requests_enabled
  }
}
