data "aws_iam_policy_document" "lambda_trust_policy" {
  statement {
    actions = ["sts:AssumeRole"]

    principals {
      type        = "Service"
      identifiers = ["lambda.amazonaws.com"]
    }
  }
}

resource "aws_iam_role" "lambda_pre_signup_role" {
  name               = "${var.project_name}-lambda-pre-signup-role"
  assume_role_policy = data.aws_iam_policy_document.lambda_trust_policy.json
}

resource "aws_iam_role_policy_attachment" "lambda_basic_execution" {
  role       = aws_iam_role.lambda_pre_signup_role.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AWSLambdaBasicExecutionRole"
}

data "aws_iam_policy_document" "lambda_pre_signup_policy" {
  statement {
    sid    = "AllowReadSharedSecret"
    effect = "Allow"
    actions = [
      "secretsmanager:GetSecretValue",
    ]
    resources = var.secrets_manager_arns
  }

  statement {
    sid    = "AllowCognitoLookup"
    effect = "Allow"
    actions = [
      "cognito-idp:AdminGetUser",
      "cognito-idp:ListUsers",
      "cognito-idp:DescribeUserPool",
    ]
    resources = [var.cognito_user_pool_arn]
  }
}

resource "aws_iam_role_policy" "lambda_pre_signup" {
  name   = "${var.project_name}-lambda-pre-signup-policy"
  role   = aws_iam_role.lambda_pre_signup_role.id
  policy = data.aws_iam_policy_document.lambda_pre_signup_policy.json
}
