resource "aws_wafv2_web_acl_rule" "rate_limits" {
  for_each = { for i, rl in var.rate_limits : rl.name => merge(rl, { priority = 4 + i }) }

  name        = "rate-limit-${each.key}"
  priority    = each.value.priority
  web_acl_arn = aws_wafv2_web_acl.main.arn

  action {
    block {}
  }

  statement {
    rate_based_statement {
      limit              = each.value.limit
      aggregate_key_type = "IP"

      scope_down_statement {
        regex_pattern_set_reference_statement {
          arn = aws_wafv2_regex_pattern_set.rate_limits[each.key].arn

          field_to_match {
            uri_path {}
          }

          text_transformation {
            priority = 0
            type     = "LOWERCASE"
          }
        }
      }
    }
  }

  visibility_config {
    cloudwatch_metrics_enabled = var.cloudwatch_metrics_enabled
    metric_name                = "${var.name_prefix}-rate-limit-${each.key}"
    sampled_requests_enabled   = var.sampled_requests_enabled
  }
}
