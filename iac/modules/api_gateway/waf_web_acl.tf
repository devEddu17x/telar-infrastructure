resource "aws_wafv2_web_acl_association" "api_waf" {
  resource_arn = aws_api_gateway_stage.stage.arn
  web_acl_arn  = var.waf_web_acl_arn
}
