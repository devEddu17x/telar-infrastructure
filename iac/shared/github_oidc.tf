resource "aws_iam_openid_connect_provider" "github" {
  url             = "https://token.actions.githubusercontent.com"
  client_id_list  = ["sts.amazonaws.com"]
  thumbprint_list = var.github_oidc_thumbprints
}

module "frontend_github_oidc_role" {
  source = "../modules/oidc/frontend_role"

  name_prefix  = local.name_prefix
  role_suffix  = "frontend-deploy"
  provider_arn = aws_iam_openid_connect_provider.github.arn
  provider_url = replace(aws_iam_openid_connect_provider.github.url, "https://", "")
  repository   = var.frontend_github_repository
  branches     = var.frontend_github_branches
  environments = var.frontend_github_environments

  ssm_parameter_arns = ["arn:aws:ssm:${var.aws_region}:${data.aws_caller_identity.current.account_id}:parameter/${var.project_name}-*/${var.frontend_parameter_path}/*"]

  s3_bucket_arns = [
    for suffix in var.frontend_bucket_suffixes :
    "arn:aws:s3:::${var.project_name}-*-${suffix}-${data.aws_caller_identity.current.account_id}"
  ]

  cloudfront_distribution_arns = [
    "arn:aws:cloudfront::${data.aws_caller_identity.current.account_id}:distribution/*"
  ]

  tags = local.default_tags
}

module "backend_github_oidc_role" {
  source = "../modules/oidc/backend_role"

  name_prefix  = local.name_prefix
  role_suffix  = "backend-deploy"
  provider_arn = aws_iam_openid_connect_provider.github.arn
  provider_url = replace(aws_iam_openid_connect_provider.github.url, "https://", "")
  repository   = var.backend_github_repository
  branches     = var.backend_github_branches
  environments = var.backend_github_environments

  ssm_parameter_arns = ["arn:aws:ssm:${var.aws_region}:${data.aws_caller_identity.current.account_id}:parameter/${var.project_name}-*/${var.backend_parameter_path}/*"]

  ecr_repository_arns = [
    "arn:aws:ecr:${var.aws_region}:${data.aws_caller_identity.current.account_id}:repository/${var.project_name}-*-api"
  ]

  ecs_cluster_arns = [
    "arn:aws:ecs:${var.aws_region}:${data.aws_caller_identity.current.account_id}:cluster/${var.project_name}-*"
  ]

  ecs_service_arns = [
    "arn:aws:ecs:${var.aws_region}:${data.aws_caller_identity.current.account_id}:service/${var.project_name}-*/*"
  ]

  ecs_task_definition_arns = [
    "arn:aws:ecs:${var.aws_region}:${data.aws_caller_identity.current.account_id}:task-definition/${var.project_name}-*:*"
  ]

  iam_role_arns = [
    "arn:aws:iam::${data.aws_caller_identity.current.account_id}:role/${var.project_name}-*-ecs-*"
  ]

  tags = local.default_tags
}
