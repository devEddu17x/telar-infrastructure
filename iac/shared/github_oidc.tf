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

module "landing_github_oidc_role" {
  source = "../modules/oidc/landing_role"

  name_prefix  = local.name_prefix
  role_suffix  = "landing-deploy"
  provider_arn = aws_iam_openid_connect_provider.github.arn
  provider_url = replace(aws_iam_openid_connect_provider.github.url, "https://", "")
  repository   = var.landing_github_repository
  branches     = var.landing_github_branches
  environments = var.landing_github_environments

  ssm_parameter_arns = ["arn:aws:ssm:${var.aws_region}:${data.aws_caller_identity.current.account_id}:parameter/${var.project_name}-*/${var.landing_parameter_path}/*"]

  s3_bucket_arns = [
    "arn:aws:s3:::${var.project_name}-*-landing-page-${data.aws_caller_identity.current.account_id}"
  ]

  cloudfront_distribution_arns = [
    "arn:aws:cloudfront::${data.aws_caller_identity.current.account_id}:distribution/*"
  ]

  tags = local.default_tags
}

module "checkov_email" {
  source = "../modules/email/ses_domain"

  domain              = var.checkov_email_domain
  mail_from_subdomain = var.checkov_email_mail_from_subdomain
}

module "checkov_email_dns" {
  source = "../modules/dns/cloudflare_email"

  zone_id                = var.cloudflare_zone_id
  domain                 = module.checkov_email.domain
  ses_verification_token = module.checkov_email.verification_token
  ses_dkim_tokens        = module.checkov_email.dkim_tokens
  mail_from_domain       = module.checkov_email.mail_from_domain
  aws_region             = var.aws_region
  dmarc_report_email     = var.checkov_email_dmarc_report_email
  manage_domain_spf      = var.checkov_email_manage_domain_spf
  manage_dmarc           = var.checkov_email_manage_dmarc
}

module "iac_github_oidc_role" {
  source = "../modules/oidc/iac_role"

  name_prefix  = local.name_prefix
  role_suffix  = "iac-checkov"
  provider_arn = aws_iam_openid_connect_provider.github.arn
  provider_url = replace(aws_iam_openid_connect_provider.github.url, "https://", "")
  repository   = var.iac_github_repository
  branches     = var.iac_github_branches
  environments = var.iac_github_environments

  from_addresses = length(var.checkov_email_from_addresses) > 0 ? var.checkov_email_from_addresses : ["no-reply-iac@${var.checkov_email_domain}"]

  tags = local.default_tags
}
