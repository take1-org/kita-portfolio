# ---------------------------------------------
# alb for app-ecs
# ---------------------------------------------

module "alb" {
  source              = "../../../modules/app-ecs/alb"
  name_prefix         = local.name_prefix
  tags                = var.tags
  common_tags         = var.common_tags
  env                 = var.env
  project             = var.project
  vpc_id              = local.vpc_id
  public_subnet_ids   = values(local.public_subnet_ids) #2025.11.4 map→listに変換
  acm_certificate_arn = local.acm_cert_arn              # us-east-1等、ALBと同一リージョン
}

/* module "target_group" {
  source      = "../../../modules/app-ecs/alb"
  name_prefix = local.name_prefix
  tags        = var.tags
  common_tags = var.common_tags
  env         = var.env
  project     = var.project
  vpc_id      = local.vpc_id
}
*/
