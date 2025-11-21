# ---------------------------------------------
# task role for ecs tasks
# ---------------------------------------------
module "ecs_task_role" {
  source = "../../../modules/iam/ecs-task-role"

  name_prefix = local.name_prefix
  env         = var.env
  region      = var.region
  tags        = var.tags
  project     = var.project
  common_tags = var.common_tags

  ssm_parameter_arns  = local.ssm_parameter_arns
  secretsmanager_arns = local.secretsmanager_arns
  kms_key_arns        = var.kms_key_arns

  #app_data remote state for s3 arns
  s3_bucket_arns = [
    data.terraform_remote_state.app_data.outputs.wp_media_bucket_arn
  ]
  s3_object_arns = [
    data.terraform_remote_state.app_data.outputs.wp_media_object_arn
  ]

}
