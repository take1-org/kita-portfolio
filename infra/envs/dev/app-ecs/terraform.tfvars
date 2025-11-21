# ---------------------------------------------
# tfvars ecs
# ---------------------------------------------
tags = {
  Environment = "dev"
  Project     = "take1-project"
  Owner       = "kita"
}
common_tags = {
  Environment = "dev"
  Project     = "take1-project"
  Owner       = "kita"
}

env     = "dev"
project = "take1-ecs"
region  = "us-east-1"

retention_in_days = 7

remote_state_bucket = "<<<your-backend-bucket>>>"
remote_state_key    = "tfstate/<<<your-project>>>/dev/foundations/terraform.tfstate"
remote_state_region = "us-east-1"

# ---------------------------------------------
# ECS Task Definition parameters
# ---------------------------------------------
task_cpu    = "256"
task_memory = "512"

# 既存の IAM ロールを remote_state などから取得済みの場合、
# ここでは明示的に書く（または data参照に置き換え可）locals.tf で取得する場合はコメントアウト可
#ecs_execution_role_arn = "arn:aws:iam::123456789012:role/take1-ecs-dev-execution-role"
#ecs_task_role_arn      = "arn:aws:iam::123456789012:role/take1-ecs-dev-task-role"

# CloudWatch Logs group
log_group_name = "/ecs/take1-ecs-dev"

# ECR イメージ（latestでもOK）locals.tf で remote_state から取得する場合はコメントアウト可
#php_image   = "123456789012.dkr.ecr.us-east-1.amazonaws.com/take1-ecs-dev-ecr-php:33fc17d-1"
#nginx_image = "123456789012.dkr.ecr.us-east-1.amazonaws.com/take1-ecs-dev-ecr-nginx:33fc17d-1"

# ---------------------------------------------
# 環境変数（現時点では空でOK。後でParameter Store連携）
# ---------------------------------------------
php_environment   = []
nginx_environment = []

desired_count = 0
