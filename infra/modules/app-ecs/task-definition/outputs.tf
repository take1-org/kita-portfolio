# ---------------------------------------------
# outputs for ecs app service task-definition
# ---------------------------------------------
output "task_definition_arn" {
  value = try(one(aws_ecs_task_definition.this[*].arn), null)
}
output "task_definition_family" {
  value = try(one(aws_ecs_task_definition.this[*].family), null)
}

output "task_definition_revision" {
  value = try(one(aws_ecs_task_definition.this[*].revision), null)
}
