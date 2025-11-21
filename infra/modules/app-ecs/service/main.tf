# ---------------------------------------------
# service for ecs
# ---------------------------------------------
resource "aws_ecs_service" "this" {
  count           = var.enable_ecs_service ? 1 : 0
  name            = "${var.name_prefix}-service"
  cluster         = var.cluster
  task_definition = var.task_definition_arn

  launch_type   = "FARGATE"
  desired_count = var.desired_count

  enable_execute_command  = true
  enable_ecs_managed_tags = true
  propagate_tags          = "SERVICE"

  availability_zone_rebalancing = "DISABLED" # 新機能：AZ自動リバランシングを有効化

  force_new_deployment = true
  network_configuration {
    subnets          = var.private_subnet_ids
    security_groups  = [aws_security_group.this[0].id]
    assign_public_ip = false
  }
  /*   load_balancer {
    target_group_arn = var.target_group_arn
    container_name   = "nginx"
    container_port   = 80
  } */
  health_check_grace_period_seconds = 180

  /*   lifecycle {
    ignore_changes = [
      task_definition # 後で :revision が増える場合に備え、明示的に更新するときだけ差し替える
    ]
  } */
  tags = merge(
    var.common_tags,
    { Name = "${var.name_prefix}-service" },
    var.tags
  )
}
