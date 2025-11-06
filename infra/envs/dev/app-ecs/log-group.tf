# ---------------------------------------------
# ecs-log-group
# ---------------------------------------------

module "ecs_log_group" {
  source            = "../../../modules/app-ecs/log-group"
  name_prefix       = local.name_prefix
  tags              = var.tags
  common_tags       = var.common_tags
  env               = var.env
  project           = var.project
  retention_in_days = var.retention_in_days
  log_group_name    = var.log_group_name
}
