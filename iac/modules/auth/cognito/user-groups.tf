resource "aws_cognito_user_group" "owner" {
  name         = "owner"
  user_pool_id = aws_cognito_user_pool.pool.id
  description  = "Platform owners with full administrative access"
  precedence   = 1
}

resource "aws_cognito_user_group" "seller" {
  name         = "seller"
  user_pool_id = aws_cognito_user_pool.pool.id
  description  = "Seller accounts with standard operational access"
  precedence   = 2
}

resource "aws_cognito_user_group" "lambda" {
  name         = "lambda"
  user_pool_id = aws_cognito_user_pool.pool.id
  description  = "Internal service accounts used by backend Lambda functions"
  precedence   = 3
}
