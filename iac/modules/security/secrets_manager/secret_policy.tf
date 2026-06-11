data "aws_iam_policy_document" "secret_resource_policy" {
  count = length(var.allowed_principal_arns) > 0 ? 1 : 0

  statement {
    sid    = "AllowGetSecretValue"
    effect = "Allow"

    principals {
      type        = "AWS"
      identifiers = var.allowed_principal_arns
    }

    actions   = ["secretsmanager:GetSecretValue"]
    resources = [aws_secretsmanager_secret.this.arn]
  }
}

resource "aws_secretsmanager_secret_policy" "this" {
  count      = length(var.allowed_principal_arns) > 0 ? 1 : 0
  secret_arn = aws_secretsmanager_secret.this.arn
  policy     = data.aws_iam_policy_document.secret_resource_policy[0].json
}
