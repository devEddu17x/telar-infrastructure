output "parameter_arns" {
  description = "ARNs of the created SSM parameters"
  value       = [for p in aws_ssm_parameter.this : p.arn]
}

output "parameter_names" {
  description = "Full names of the created SSM parameters"
  value       = [for p in aws_ssm_parameter.this : p.name]
}

output "parameters_by_name" {
  description = "Map of parameter short name to full parameter name"
  value       = { for k, p in aws_ssm_parameter.this : k => p.name }
}
