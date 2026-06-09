resource "aws_lambda_permission" "this" {
  for_each = var.lambdas

  statement_id  = "AllowCognitoInvoke-${each.key}"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.lambda[each.key].function_name
  principal     = "cognito-idp.amazonaws.com"
  source_arn    = var.user_pool_arn
}
