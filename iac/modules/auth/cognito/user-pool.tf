resource "aws_cognito_user_pool" "pool" {

  name = "${var.name_prefix}-user-pool"

  auto_verified_attributes = ["email"]

  verification_message_template {
    email_subject = "${var.app_email_subject} - Verify your email"
    email_message = "Your verification code is {####}"
  }

  password_policy {
    minimum_length                   = 8
    require_uppercase                = true
    require_lowercase                = true
    require_numbers                  = true
    require_symbols                  = true
    temporary_password_validity_days = 7
  }

  mfa_configuration = var.mfa_configuration

  schema {
    name                = "email"
    required            = true
    mutable             = true
    attribute_data_type = "String"

    string_attribute_constraints {
      min_length = 5
      max_length = 254
    }
  }

  lambda_config {
    pre_sign_up = var.pre_signup_lambda_arn
  }

  account_recovery_setting {
    recovery_mechanism {
      name     = "verified_email"
      priority = 1
    }
  }
}
