resource "aws_signer_signing_profile" "this" {
  count       = var.enable_code_signing ? 1 : 0
  name_prefix = substr(replace(var.function_name, "/[^a-zA-Z0-9]/", ""), 0, 38)
  platform_id = "AWSLambda-SHA384-ECDSA"
}

resource "aws_lambda_code_signing_config" "this" {
  count = var.enable_code_signing ? 1 : 0
  allowed_publishers {
    signing_profile_version_arns = [aws_signer_signing_profile.this[0].version_arn]
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
  code_signing_config_arn = var.enable_code_signing ? aws_lambda_code_signing_config.this[0].arn : null
  # checkov:skip=CKV_AWS_115: B2B tenant signup is extremely low traffic; no risk of exhausting account concurrency limits.
  # checkov:skip=CKV_AWS_272: Code signing is disabled for local deployment to allow dynamic packaging without a signature process.

  environment {
    variables = var.environment_variables
  }

  tracing_config {
    mode = "Active"
  }

  tags = var.tags
}

