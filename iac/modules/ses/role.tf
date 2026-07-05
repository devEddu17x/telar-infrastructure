data "aws_caller_identity" "current" {}
data "aws_region" "current" {}

data "aws_iam_policy_document" "assume_role" {
  statement {
    actions = ["sts:AssumeRoleWithWebIdentity"]

    principals {
      type        = "Federated"
      identifiers = [var.github_oidc_provider_arn]
    }

    condition {
      test     = "StringEquals"
      variable = "${var.github_oidc_provider_url}:aud"
      values   = ["sts.amazonaws.com"]
    }

    condition {
      test     = "StringLike"
      variable = "${var.github_oidc_provider_url}:sub"
      values = concat(
        [for branch in var.github_branches : "repo:${var.github_repository}:ref:refs/heads/${branch}"],
        [for env in var.github_environments : "repo:${var.github_repository}:environment:${env}"]
      )
    }
  }
}

resource "aws_iam_role" "github_actions_ses" {
  name               = "${var.name_prefix}-github-actions-ses"
  assume_role_policy = data.aws_iam_policy_document.assume_role.json
  tags               = var.tags
}

data "aws_iam_policy_document" "ses_send" {
  statement {
    sid = "SendEmails"
    actions = [
      "ses:SendEmail",
      "ses:SendRawEmail"
    ]
    resources = concat(
      [for email in var.emails : "arn:aws:ses:${data.aws_region.current.name}:${data.aws_caller_identity.current.account_id}:identity/${email}"],
      var.domain != "" ? ["arn:aws:ses:${data.aws_region.current.name}:${data.aws_caller_identity.current.account_id}:identity/${var.domain}"] : []
    )
  }
}

resource "aws_iam_policy" "ses_send" {
  name        = "${var.name_prefix}-ses-send-policy"
  description = "Allows sending emails via SES"
  policy      = data.aws_iam_policy_document.ses_send.json
  tags        = var.tags
}

resource "aws_iam_role_policy_attachment" "ses_send_attach" {
  role       = aws_iam_role.github_actions_ses.name
  policy_arn = aws_iam_policy.ses_send.arn
}
