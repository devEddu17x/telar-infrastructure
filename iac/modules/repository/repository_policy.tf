data "aws_iam_policy_document" "ecr_cross_account" {
  count = length(var.allowed_principal_arns) > 0 ? 1 : 0

  statement {
    sid    = "AllowCrossAccountPull"
    effect = "Allow"

    principals {
      type        = "AWS"
      identifiers = var.allowed_principal_arns
    }

    actions = [
      "ecr:GetDownloadUrlForLayer",
      "ecr:BatchGetImage",
      "ecr:BatchCheckLayerAvailability",
    ]
  }
}

resource "aws_ecr_repository_policy" "this" {
  count      = length(var.allowed_principal_arns) > 0 ? 1 : 0
  repository = aws_ecr_repository.this.name

  policy = data.aws_iam_policy_document.ecr_cross_account[0].json
}
