# ---------------------------------------------
# output for ecs execution role
# ---------------------------------------------
output "role_name" {
  value = var.enable_execution_role ? one(aws_iam_role.this[*].name) : null
}

output "role_arn" {
  value = var.enable_execution_role ? one(aws_iam_role.this[*].arn) : null
}

