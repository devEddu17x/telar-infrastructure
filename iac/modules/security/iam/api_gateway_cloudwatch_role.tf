data "aws_iam_policy_document" "api_gateway_cloudwatch_trust" {
  statement {
    actions = ["sts:AssumeRole"]

    principals {
      type        = "Service"
      identifiers = ["apigateway.amazonaws.com"]
    }
  }
}

resource "aws_iam_role" "api_gateway_cloudwatch" {
  name               = "${var.name_prefix}-apigw-cloudwatch-role"
  assume_role_policy = data.aws_iam_policy_document.api_gateway_cloudwatch_trust.json
}

resource "aws_iam_role_policy_attachment" "api_gateway_cloudwatch_managed" {
  role       = aws_iam_role.api_gateway_cloudwatch.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonAPIGatewayPushToCloudWatchLogs"
}
