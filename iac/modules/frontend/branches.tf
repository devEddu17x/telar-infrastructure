resource "aws_amplify_branch" "main" {
  app_id      = aws_amplify_app.frontend.id
  branch_name = var.branch

  framework         = var.framework
  stage             = var.branch_stage
  enable_auto_build = true

  environment_variables = {}

  tags = var.tags
}
