resource "aws_wafv2_web_acl_association" "amplify_frontend" {
  count = var.web_acl_arn != "" ? 1 : 0

  resource_arn = aws_amplify_app.frontend.arn
  web_acl_arn  = var.web_acl_arn

  depends_on = [aws_amplify_app.frontend]
}
