resource "aws_iam_role" "lambda_role" {
  for_each = var.lambdas
  name               = "${var.name_prefix}-${each.key}-role"
  assume_role_policy = data.aws_iam_policy_document.lambda_assume_role.json
}

resource "aws_iam_role_policy_attachment" "basic_execution" {
  for_each = var.lambdas

  role       = aws_iam_role.lambda_role[each.key].name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AWSLambdaBasicExecutionRole"
}

resource "aws_iam_role_policy" "custom_policy" {
  for_each = { for k, v in var.lambdas : k => v if v.role_policy != null && v.role_policy != "" }

  name   = "${var.name_prefix}-${each.key}-custom-policy"
  role   = aws_iam_role.lambda_role[each.key].id
  policy = each.value.role_policy
}
