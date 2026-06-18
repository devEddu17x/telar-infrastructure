resource "aws_amplify_app" "frontend" {
  name         = "${var.name_prefix}-frontend"
  repository   = var.repository_url
  platform     = "WEB_COMPUTE"
  access_token = var.github_access_token != "" ? var.github_access_token : null

  build_spec = <<-YAML
    version: 1
    frontend:
      phases:
        preBuild:
          commands:
            - nvm use ${var.node_version}
            - corepack enable
            - corepack prepare pnpm@latest --activate
            - rm -rf node_modules
            - echo "shamefully-hoist=true" >> .npmrc
            - pnpm install --frozen-lockfile --dangerously-allow-all-builds
        build:
          commands:
            - pnpm run build
      artifacts:
        baseDirectory: .next
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
    NEXT_PUBLIC_AWS_COGNITO_CLIENT_ID      = var.cognito_client_id
    NEXT_PUBLIC_AWS_COGNITO_REGION         = var.aws_region
    NEXT_PUBLIC_API_BASE_URL               = var.api_base_url
    NEXT_PUBLIC_API_URL                    = var.api_url
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

resource "null_resource" "start_first_deployment" {
  depends_on = [aws_amplify_branch.main]

  triggers = {
    app_id      = aws_amplify_app.frontend.id
    branch_name = aws_amplify_branch.main.branch_name
  }

  provisioner "local-exec" {
    command = <<-EOT
      AWS_PAGER="" aws amplify start-job \
        --app-id ${aws_amplify_app.frontend.id} \
        --branch-name ${aws_amplify_branch.main.branch_name} \
        --job-type RELEASE \
        --region ${var.aws_region} \
        ${var.aws_profile != "" ? "--profile ${var.aws_profile}" : ""}
    EOT
  }
}
