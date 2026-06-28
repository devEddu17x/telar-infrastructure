resource "aws_cloudwatch_log_group" "ecs_api" {
  name              = "${var.name_prefix}-api-logs"
  retention_in_days = 365
  tags              = var.tags
}

resource "aws_cloudwatch_log_group" "api_gateway_access" {
  name              = "${var.name_prefix}-api-gateway-access-logs"
  retention_in_days = 365
  tags              = var.tags
}
