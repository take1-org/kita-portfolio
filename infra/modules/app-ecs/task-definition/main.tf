###############################################
# ECS Task Definition (Fargate, Nginx + PHP-FPM)
# File: modules/app-ecs/task-definition/main.tf
###############################################

resource "aws_ecs_task_definition" "this" {
  count                    = var.enable_task_definition ? 1 : 0
  family                   = "${var.family_prefix}-td"
  requires_compatibilities = ["FARGATE"]
  network_mode             = "awsvpc"
  cpu                      = var.task_cpu
  memory                   = var.task_memory
  execution_role_arn       = var.execution_role_arn
  task_role_arn            = var.task_role_arn

  runtime_platform {
    operating_system_family = "LINUX"
    cpu_architecture        = "X86_64"
  }

  container_definitions = jsonencode([
    local.php_container,
    local.nginx_container
  ])

  # ソケット用：タスク内エフェメラル（emptyDir的）
  volume {
    name = "php_runtime"
  }
  # ★ 追加：WPコア用エフェメラル
  volume {
    name = "wp_root"
  }

  dynamic "volume" {
    for_each = (
      var.enable_efs
      && var.efs_file_system_id != null
      && var.efs_access_point_id != null
    ) ? [1] : []
    content {
      name = "efs_wpcontent"
      efs_volume_configuration {
        file_system_id     = var.efs_file_system_id
        transit_encryption = "ENABLED"
        authorization_config {
          access_point_id = var.efs_access_point_id
          iam             = "ENABLED"
        }
      }
    }
  }
  # ✅ precondition は resource 直下に置く（Terraform >= 1.2）
  lifecycle {
    precondition {
      condition = (
        var.enable_efs == false ||
        (var.efs_file_system_id != null && var.efs_access_point_id != null)
      )
      error_message = "enable_efs=true の場合は efs_file_system_id と efs_access_point_id の両方が必要です。"
    }
  }
  tags = merge(
    var.common_tags,
    { Name = "${var.family_prefix}-taskdef" },
    var.tags
  )
}
