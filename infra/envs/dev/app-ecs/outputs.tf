# ---------------------------------------------
# outputs ecs
# ---------------------------------------------

output "ecs_log_group_name" {
  description = "The name of the ECS CloudWatch log group"
  value       = module.ecs_log_group.log_group_name
}
output "ecs_log_group_arn" {
  description = "The ARN of the ECS CloudWatch log group"
  value       = module.ecs_log_group.log_group_arn
}

output "ecs_task_definition_arn" {

  description = "The ARN of the ECS task definition"
  value       = module.ecs_task_definition.task_definition_arn
}

output "alb_dns_name" {
  description = "The DNS name of the ALB"
  value       = module.alb.alb_dns_name
}
