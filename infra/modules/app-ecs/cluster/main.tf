# ---------------------------------------------
# ecs cluster
# ---------------------------------------------

resource "aws_ecs_cluster" "this" {
  count = var.enable_ecs_cluster ? 1 : 0
  name  = "${var.name_prefix}-woocommerce-cluster"
  # Observability
  setting {
    name  = "containerInsights"
    value = var.enable_container_insights ? "enabled" : "disabled"
  }

  # ECS Exec
  dynamic "configuration" {
    for_each = var.enable_exec ? [1] : []
    content {
      execute_command_configuration {
        # logging = DEFAULT | OVERRIDE（DEFAULT = CloudWatch Logs or S3 per task）
        logging    = "DEFAULT"
        kms_key_id = var.exec_kms_key_arn # ← ここは属性。nullなら無視される
      }
    }
  }

  tags = merge(
    var.common_tags,
    {
      Name = "${var.name_prefix}-woocommerce-cluster"
    },
    var.tags,
  )
}

# Capacity Providers
resource "aws_ecs_cluster_capacity_providers" "this" {
  count              = var.enable_ecs_cluster ? 1 : 0
  cluster_name       = aws_ecs_cluster.this[0].name
  capacity_providers = var.enable_fargate_spot ? ["FARGATE", "FARGATE_SPOT"] : ["FARGATE"]

  dynamic "default_capacity_provider_strategy" {
    for_each = var.enable_fargate_spot ? [
      { base = 1, name = "FARGATE", weight = 1 },
      { base = 0, name = "FARGATE_SPOT", weight = 1 }
      ] : [
      { base = 1, name = "FARGATE", weight = 1 }
    ]
    content {
      capacity_provider = default_capacity_provider_strategy.value.name
      weight            = default_capacity_provider_strategy.value.weight
      base              = default_capacity_provider_strategy.value.base
    }
  }
}
