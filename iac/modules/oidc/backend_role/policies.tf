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
    sid = "ReadBackendParameters"
    actions = [
      "ssm:GetParameter",
      "ssm:GetParameters",
      "ssm:GetParametersByPath",
    ]
    resources = var.ssm_parameter_arns
  }

  statement {
    sid       = "AuthenticateECR"
    actions   = ["ecr:GetAuthorizationToken"]
    resources = ["*"]
  }

  statement {
    sid = "PushBackendImage"
    actions = [
      "ecr:BatchCheckLayerAvailability",
      "ecr:BatchGetImage",
      "ecr:CompleteLayerUpload",
      "ecr:DescribeImages",
      "ecr:DescribeRepositories",
      "ecr:GetDownloadUrlForLayer",
      "ecr:InitiateLayerUpload",
      "ecr:PutImage",
      "ecr:UploadLayerPart",
    ]
    resources = var.ecr_repository_arns
  }

  statement {
    sid = "DeployBackendService"
    actions = [
      "ecs:DescribeClusters",
      "ecs:DescribeServices",
    ]
    resources = concat(var.ecs_cluster_arns, var.ecs_service_arns)
  }

  statement {
    sid = "UpdateBackendService"
    actions = [
      "ecs:UpdateService",
    ]
    resources = var.ecs_service_arns
  }

  statement {
    sid = "ManageBackendTaskDefinition"
    actions = [
      "ecs:DescribeTaskDefinition",
      "ecs:RegisterTaskDefinition",
    ]
    resources = var.ecs_task_definition_arns
  }

  statement {
    sid       = "PassBackendTaskRoles"
    actions   = ["iam:PassRole"]
    resources = var.iam_role_arns

    condition {
      test     = "StringEquals"
      variable = "iam:PassedToService"
      values   = ["ecs-tasks.amazonaws.com"]
    }
  }
}
