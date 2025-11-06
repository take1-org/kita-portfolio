# ---------------------------------------------
# outputs ecs-log-group
# ---------------------------------------------
output "log_group_name" {
  description = "The name of the CloudWatch log group"
  value       = var.enable_ecs_log_group ? one(aws_cloudwatch_log_group.this[*].name) : null
}

output "log_group_arn" {
  description = "The ARN of the CloudWatch log group"
  value       = var.enable_ecs_log_group ? one(aws_cloudwatch_log_group.this[*].arn) : null
}
