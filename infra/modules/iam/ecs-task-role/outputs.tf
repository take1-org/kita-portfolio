# ---------------------------------------------
# output for ecs task role
# ---------------------------------------------
output "role_name" {
  value = var.enable_task_role ? one(aws_iam_role.this[*].name) : null
}

output "role_arn" {
  value = var.enable_task_role ? one(aws_iam_role.this[*].arn) : null
}
