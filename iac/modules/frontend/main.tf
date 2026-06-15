resource "aws_amplify_app" "frontend" {
  name         = "${var.name_prefix}-frontend"
  repository   = var.repository_url
  access_token = var.github_access_token

  build_spec = <<-YAML
    version: 1
    frontend:
      phases:
        preBuild:
          commands:
            - nvm use ${var.node_version}
            - npm ci
        build:
          commands:
            - npm run build
      artifacts:
        baseDirectory: out
        files:
          - '**/*'
      cache:
        paths:
          - node_modules/**/*
          - .next/cache/**/*
  YAML

  environment_variables = {
    NEXT_PUBLIC_COGNITO_USER_POOL_ID       = var.cognito_user_pool_id
    NEXT_PUBLIC_COGNITO_USER_POOL_ENDPOINT = var.cognito_user_pool_endpoint
    NEXT_PUBLIC_COGNITO_CLIENT_ID          = var.cognito_client_id
    NEXT_PUBLIC_API_BASE_URL               = var.api_base_url
    AMPLIFY_MONOREPO_APP_ROOT              = "."
    _LIVE_UPDATES                          = jsonencode([{ name = "Node.js version", pkg = "node", type = "nvm", version = var.node_version }])
  }

  auto_branch_creation_config {
    enable_auto_build           = true
    enable_pull_request_preview = true
  }

  enable_auto_branch_creation = true
  enable_branch_auto_build    = true
  enable_branch_auto_deletion = true

  tags = var.tags
}
