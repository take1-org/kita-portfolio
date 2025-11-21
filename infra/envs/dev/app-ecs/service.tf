# ---------------------------------------------
# sercvice for app-ecs
# ---------------------------------------------
module "ecs_service" {
  source = "../../../modules/app-ecs/service"

  name_prefix        = "${local.name_prefix}-woocommerce-service"
  vpc_id             = local.vpc_id
  private_subnet_ids = [local.private_subnet_id_1a] # 1AZのみ

  cluster             = module.ecs_cluster.cluster_name
  cluster_arn         = module.ecs_cluster.cluster_arn
  task_definition_arn = module.ecs_task_definition.task_definition_arn
  alb_sg_id           = module.alb.alb_sg_id # ALBのSGを指定  2025.11.4
  desired_count       = var.desired_count

  target_group_arn = module.alb.tg_arn

  env         = var.env
  common_tags = var.common_tags
  tags        = var.tags

  depends_on = [module.ecs_task_definition]
}
