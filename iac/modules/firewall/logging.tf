resource "aws_wafv2_web_acl_logging_configuration" "main" {
  count = length(var.log_destination_arns) > 0 ? 1 : 0

  resource_arn = aws_wafv2_web_acl.main.arn

  log_destination_configs = [for arn in var.log_destination_arns : trimsuffix(arn, ":*")]

  dynamic "redacted_fields" {
    for_each = var.logging_redacted_fields
    content {
      single_header {
        name = lower(redacted_fields.value)
      }
    }
  }
}