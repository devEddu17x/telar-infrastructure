resource "aws_cognito_user_pool" "pool" {

  name = "${var.name_prefix}-user-pool"

  auto_verified_attributes = ["email"]

  verification_message_template {
    default_email_option = "CONFIRM_WITH_CODE"
    email_subject        = "${var.app_email_subject} - Verifica tu correo"
    email_message        = var.verification_email_message
  }

  password_policy {
    minimum_length                   = 12
    require_uppercase                = true
    require_lowercase                = true
    require_numbers                  = true
    require_symbols                  = true
    temporary_password_validity_days = 7
  }

  schema {
    name                = "email"
    required            = true
    mutable             = false
    attribute_data_type = "String"
  }

  schema {
    name                = "tenant_id"
    mutable             = true
    required            = false
    attribute_data_type = "String"
  }

  lambda_config {
    pre_sign_up = var.pre_signup_lambda_arn
  }

  lifecycle {
    ignore_changes = [schema]
  }
}
