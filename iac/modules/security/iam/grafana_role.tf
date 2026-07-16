data "aws_iam_policy_document" "grafana_trust" {
  statement {
    effect = "Allow"

    principals {
      type        = "Service"
      identifiers = ["grafana.amazonaws.com"]
    }

    actions = ["sts:AssumeRole"]
  }
}

resource "aws_iam_role" "grafana" {
  name               = "${var.name_prefix}-grafana-role"
  assume_role_policy = data.aws_iam_policy_document.grafana_trust.json
}

resource "aws_iam_role_policy_attachment" "grafana_cloudwatch" {
  role       = aws_iam_role.grafana.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonGrafanaCloudWatchAccess"
}
