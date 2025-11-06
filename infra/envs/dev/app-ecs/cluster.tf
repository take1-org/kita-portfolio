# ---------------------------------------------
# ecs cluster
# ---------------------------------------------

module "ecs_cluster" {
  source      = "../../../modules/app-ecs/cluster"
  name_prefix = local.name_prefix
  tags        = var.tags
  common_tags = var.common_tags
  env         = var.env
  project     = var.project

}
