resource "aws_wafv2_web_acl" "main" {
  name        = "${var.name_prefix}-web-acl"
  description = "WAFv2 Web ACL for ${var.name_prefix} (scope ${var.scope})"
  scope       = var.scope

  default_action {
    dynamic "allow" {
      for_each = var.default_action == "allow" ? [1] : []
      content {}
    }

    dynamic "block" {
      for_each = var.default_action == "block" ? [1] : []
      content {}
    }
  }

  # Rule 1 - AWS Managed Rules: Common Rule Set (OWASP-style baseline protections)
  rule {
    name     = "aws-managed-common-rule-set"
    priority = 1

    override_action {
      dynamic "none" {
        for_each = var.common_rule_set_count_only ? [] : [1]
        content {}
      }

      dynamic "count" {
        for_each = var.common_rule_set_count_only ? [1] : []
        content {}
      }
    }

    statement {
      managed_rule_group_statement {
        name        = "AWSManagedRulesCommonRuleSet"
        vendor_name = "AWS"

        # Force specific rules into count mode (e.g. to mitigate false positives)
        dynamic "rule_action_override" {
          for_each = var.common_rule_set_count_overrides
          content {
            name = rule_action_override.value
            action_to_use {
              count {}
            }
          }
        }
      }
    }

    visibility_config {
      cloudwatch_metrics_enabled = var.cloudwatch_metrics_enabled
      metric_name                = "${var.name_prefix}-common-rule-set"
      sampled_requests_enabled   = var.sampled_requests_enabled
    }
  }

  # Rule 2 - Rate limiting: block IPs that exceed the request threshold
  rule {
    name     = "rate-limit"
    priority = 2

    action {
      block {}
    }

    statement {
      rate_based_statement {
        limit              = var.rate_limit
        aggregate_key_type = "IP"
      }
    }

    visibility_config {
      cloudwatch_metrics_enabled = var.cloudwatch_metrics_enabled
      metric_name                = "${var.name_prefix}-rate-limit"
      sampled_requests_enabled   = var.sampled_requests_enabled
    }
  }

  visibility_config {
    cloudwatch_metrics_enabled = var.cloudwatch_metrics_enabled
    metric_name                = "${var.name_prefix}-web-acl"
    sampled_requests_enabled   = var.sampled_requests_enabled
  }

  tags = var.tags
}