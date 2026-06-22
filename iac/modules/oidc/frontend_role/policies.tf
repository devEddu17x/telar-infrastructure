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
      values   = concat([for branch in var.branches : "repo:${var.repository}:ref:refs/heads/${branch}"], [for environment in var.environments : "repo:${var.repository}:environment:${environment}"])
    }
  }
}

data "aws_iam_policy_document" "deploy" {
  statement {
    sid = "ReadFrontendParameters"
    actions = [
      "ssm:GetParameter",
      "ssm:GetParameters",
      "ssm:GetParametersByPath",
    ]
    resources = var.ssm_parameter_arns
  }

  statement {
    sid = "ListFrontendBuckets"
    actions = [
      "s3:GetBucketLocation",
      "s3:ListBucket",
    ]
    resources = var.s3_bucket_arns
  }

  statement {
    sid = "SyncFrontendObjects"
    actions = [
      "s3:DeleteObject",
      "s3:GetObject",
      "s3:PutObject",
    ]
    resources = [for arn in var.s3_bucket_arns : "${arn}/*"]
  }

  statement {
    sid = "InvalidateFrontendDistributions"
    actions = [
      "cloudfront:CreateInvalidation",
      "cloudfront:GetDistribution",
    ]
    resources = var.cloudfront_distribution_arns
  }
}
