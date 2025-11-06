# ---------------------------------------------
# task-definition for ecs app service
# ---------------------------------------------
module "ecs_task_definition" {
  source = "../../../modules/app-ecs/task-definition"

  name_prefix   = local.name_prefix
  family_prefix = var.family_prefix
  task_cpu      = var.task_cpu
  task_memory   = var.task_memory
  region        = var.region


  execution_role_arn = local.ecs_execution_role_arn
  task_role_arn      = local.ecs_task_role_arn
  log_group_name     = var.log_group_name

  php_image   = local.php_image
  nginx_image = local.nginx_image

  php_environment   = var.php_environment
  nginx_environment = var.nginx_environment

  efs_access_point_id = module.efs.efs_access_point_id
  efs_file_system_id  = module.efs.efs_file_system_id

  #enable_container_insights = var.enable_container_insights
  tags        = var.tags
  common_tags = var.common_tags
}

