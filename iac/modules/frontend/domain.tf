resource "aws_amplify_domain_association" "frontend" {
  count = var.domain_name != "" ? 1 : 0

  app_id                = aws_amplify_app.frontend.id
  domain_name           = var.domain_name
  wait_for_verification = false

  sub_domain {
    branch_name = aws_amplify_branch.main.branch_name
    prefix      = ""
  }

  depends_on = [aws_amplify_branch.main]
}
