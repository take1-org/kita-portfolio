# ---------------------------------------------
# outputs for ecs-execution-rol
# ---------------------------------------------
output "ecs_execution_role_name" {
  value = module.ecs_execution_role.role_name
}

output "ecs_execution_role_arn" {
  value = module.ecs_execution_role.role_arn
}

output "ecs_task_role_name" {
  value = module.ecs_task_role.role_name
}

output "ecs_task_role_arn" {
  value = module.ecs_task_role.role_arn
}
