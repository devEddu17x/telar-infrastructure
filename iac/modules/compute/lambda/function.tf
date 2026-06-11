resource "aws_lambda_function" "this" {
  function_name    = var.function_name
  filename         = var.filename
  source_code_hash = var.source_code_hash
  handler          = var.handler
  runtime          = var.runtime
  role             = var.role_arn

  environment {
    variables = var.environment_variables
  }

  tags = var.tags
}
