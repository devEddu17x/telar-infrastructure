resource "aws_apigatewayv2_stage" "stage" {
  api_id      = aws_apigatewayv2_api.main.id
  name        = var.api_stage
  auto_deploy = true

  access_log_settings {
    destination_arn = var.access_log_group_arn
    format          = var.access_log_format
  }

  tags = var.tags
}
