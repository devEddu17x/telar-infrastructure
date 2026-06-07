output "target_id" {
  value = aws_appautoscaling_target.this.id
}

output "policy_arn" {
  value = aws_appautoscaling_policy.this.arn
}
