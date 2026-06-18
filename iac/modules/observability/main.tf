resource "aws_cloudwatch_log_group" "ecs_api" {
  name              = "${var.name_prefix}-api-logs"
  retention_in_days = var.retention_in_days
  tags              = var.tags
}

resource "aws_cloudwatch_log_group" "api_gateway_access" {
  name              = "${var.name_prefix}-api-gateway-access-logs"
  retention_in_days = var.retention_in_days
  tags              = var.tags
}
