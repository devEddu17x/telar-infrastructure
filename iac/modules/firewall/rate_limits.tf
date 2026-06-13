resource "aws_wafv2_regex_pattern_set" "rate_limits" {
  for_each = { for rl in var.rate_limits : rl.name => rl }

  name        = "${var.name_prefix}-rate-limit-${each.key}"
  description = "Regex patterns for rate limit rule ${each.key}"
  scope       = var.scope

  dynamic "regular_expression" {
    for_each = each.value.regex_patterns
    content {
      regex_string = regular_expression.value
    }
  }

  tags = var.tags
}
