resource "aws_signer_signing_profile" "this" {
  name_prefix = var.function_name
  platform_id = "AWSLambda-SHA384-ECDSA"
}

resource "aws_lambda_code_signing_config" "this" {
  allowed_publishers {
    signing_profile_version_arns = [aws_signer_signing_profile.this.version_arn]
  }

  policies {
    untrusted_artifact_on_deployment = "Enforce"
  }
}

resource "aws_lambda_function" "this" {
  function_name           = var.function_name
  filename                = var.filename
  source_code_hash        = var.source_code_hash
  handler                 = var.handler
  runtime                 = var.runtime
  role                    = var.role_arn
  code_signing_config_arn = aws_lambda_code_signing_config.this.arn

  environment {
    variables = var.environment_variables
  }

  tracing_config {
    mode = "Active"
  }

  tags = var.tags
}
