# ---------------------------------------------
# efs for app-ecs
# ---------------------------------------------


module "efs" {
  source = "../../../modules/app-ecs/efs"

  name_prefix     = "${local.name_prefix}-efs"
  vpc_id          = local.vpc_id
  subnet_id       = local.private_subnet_id_1a
  ecs_tasks_sg_id = module.ecs_service.ecs_task_sg_id
  # www-data
  posix_uid   = 33
  posix_gid   = 33
  ap_root_dir = "/wp-content"
  env         = var.env
  common_tags = var.common_tags
  tags        = var.tags
}


