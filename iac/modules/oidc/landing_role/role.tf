resource "aws_iam_role" "this" {
  name               = "${var.name_prefix}-${var.role_suffix}"
  assume_role_policy = data.aws_iam_policy_document.assume_role.json
  tags               = var.tags
}

resource "aws_iam_policy" "deploy" {
  name   = "${var.name_prefix}-${var.role_suffix}-policy"
  policy = data.aws_iam_policy_document.deploy.json
  tags   = var.tags
}

resource "aws_iam_role_policy_attachment" "deploy" {
  role       = aws_iam_role.this.name
  policy_arn = aws_iam_policy.deploy.arn
}
