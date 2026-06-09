output "lambda_arns" {
  description = "Map of Lambda ARNs keyed by function name"
  value       = { for k, fn in aws_lambda_function.lambda : k => fn.arn }
}

output "lambda_function_names" {
  description = "Map of Lambda function names keyed by function name"
  value       = { for k, fn in aws_lambda_function.lambda : k => fn.function_name }
}
