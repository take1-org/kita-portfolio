# ---------------------------------------------
# log-group ecs
# ---------------------------------------------

resource "aws_cloudwatch_log_group" "this" {
  count             = var.enable_ecs_log_group ? 1 : 0
  name              = var.log_group_name != "" ? var.log_group_name : "/ecs/${var.name_prefix}/app"
  retention_in_days = var.retention_in_days

  tags = merge(
    var.tags,
    var.common_tags,
    {
      Name = var.log_group_name != "" ? var.log_group_name : "/ecs/${var.name_prefix}/app"
    }
  )
}
