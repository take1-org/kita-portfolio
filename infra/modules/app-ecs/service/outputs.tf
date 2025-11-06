# ---------------------------------------------
# outputs for app-ecs-service
# ---------------------------------------------

output "service_arn" {
  value = try(one(aws_ecs_service.this[*].arn), null)
}

output "service_name" {
  value = try(one(aws_ecs_service.this[*].name), null)
}

output "ecs_task_sg_id" {
  value = try(one(aws_security_group.this[*].id), null)
}
