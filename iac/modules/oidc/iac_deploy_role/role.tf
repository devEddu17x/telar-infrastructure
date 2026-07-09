resource "aws_iam_role" "this" {
  name               = "${var.name_prefix}-${var.role_suffix}"
  assume_role_policy = data.aws_iam_policy_document.assume_role.json
  tags               = var.tags
}

resource "aws_iam_policy" "email" {
  name   = "${var.name_prefix}-${var.role_suffix}-email-policy"
  policy = data.aws_iam_policy_document.email.json
  tags   = var.tags
}

resource "aws_iam_role_policy_attachment" "managed" {
  for_each = toset(var.managed_policy_arns)

  role       = aws_iam_role.this.name
  policy_arn = each.value
}

resource "aws_iam_role_policy_attachment" "email" {
  role       = aws_iam_role.this.name
  policy_arn = aws_iam_policy.email.arn
}
