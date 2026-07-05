data "aws_iam_policy_document" "assume_role" {
  statement {
    actions = ["sts:AssumeRoleWithWebIdentity"]

    principals {
      type        = "Federated"
      identifiers = [var.provider_arn]
    }

    condition {
      test     = "StringEquals"
      variable = "${var.provider_url}:aud"
      values   = ["sts.amazonaws.com"]
    }

    condition {
      test     = "StringLike"
      variable = "${var.provider_url}:sub"
      values = concat(
        [for branch in var.branches : "repo:${var.repository}:ref:refs/heads/${branch}"],
        [for environment in var.environments : "repo:${var.repository}:environment:${environment}"],
        var.allow_pull_requests ? ["repo:${var.repository}:pull_request"] : []
      )
    }
  }
}

data "aws_iam_policy_document" "deploy" {
  statement {
    sid = "SendCheckovReports"
    actions = [
      "ses:SendEmail",
      "ses:SendRawEmail",
    ]
    resources = ["*"]

    condition {
      test     = "StringEquals"
      variable = "ses:FromAddress"
      values   = var.from_addresses
    }
  }
}
