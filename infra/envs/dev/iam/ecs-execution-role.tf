# ---------------------------------------------
# iam role for ecs-execution-role
# ---------------------------------------------
module "ecs_execution_role" {
  source      = "../../../modules/iam/ecs-execution-role"
  name_prefix = local.name_prefix
  env         = var.env
  region      = var.region
  tags        = var.tags
  project     = var.project
  common_tags = var.common_tags

  ssm_parameter_arns  = local.ssm_parameter_arns
  secretsmanager_arns = local.secretsmanager_arns
  kms_key_arns        = var.kms_key_arns
}
