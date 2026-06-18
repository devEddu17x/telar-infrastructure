resource "aws_cognito_user_pool_lambda_config" "pre_signup" {
  user_pool_id = var.cognito_user_pool_id
  pre_sign_up  = var.lambda_function_arn
}

resource "aws_lambda_permission" "allow_cognito" {
  statement_id  = "AllowCognitoInvoke"
  action        = "lambda:InvokeFunction"
  function_name = var.lambda_function_name
  principal     = "cognito-idp.amazonaws.com"
  source_arn    = var.cognito_user_pool_arn
}
