variable "cognito_user_pool_id" {
  description = "ID of the Cognito User Pool to attach the Lambda trigger to"
  type        = string
}

variable "cognito_user_pool_arn" {
  description = "ARN of the Cognito User Pool for the Lambda permission source"
  type        = string
}

variable "lambda_function_arn" {
  description = "ARN of the Lambda function to invoke as a Cognito trigger"
  type        = string
}

variable "lambda_function_name" {
  description = "Name of the Lambda function for the permission resource"
  type        = string
}
