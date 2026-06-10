resource "aws_cognito_user_group" "owner" {
  name         = "owner"
  user_pool_id = aws_cognito_user_pool.pool.id
}

resource "aws_cognito_user_group" "admin" {
  name         = "admin"
  user_pool_id = aws_cognito_user_pool.pool.id
}

resource "aws_cognito_user_group" "seller" {
  name         = "seller"
  user_pool_id = aws_cognito_user_pool.pool.id
}
