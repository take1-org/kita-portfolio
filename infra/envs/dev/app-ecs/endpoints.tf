# ---------------------------------------------
# endpoint for app-ecs
# ---------------------------------------------

module "ecs_vpc_endpoints" {
  source      = "../../../modules/app-ecs/vpc-endpoints"
  name_prefix = local.name_prefix
  region      = var.region

  vpc_id          = local.vpc_id
  vpc_cidr_block  = local.vpc_cidr
  subnet_ids      = [local.private_subnet_id_1a]      # 1AZのみ
  ecs_tasks_sg_id = module.ecs_service.ecs_task_sg_id #+2025.11.4
  env             = var.env
  common_tags     = var.common_tags
  tags            = var.tags
}
