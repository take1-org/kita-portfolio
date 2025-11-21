# ---------------------------------------------
# Locals for ecs task role
# ---------------------------------------------
locals {
  name_prefix           = "${var.project}-${var.env}"
  enable_ssm_policy     = var.enable_task_role && length(var.ssm_parameter_arns) > 0
  enable_secrets_policy = var.enable_task_role && length(var.secretsmanager_arns) > 0
  enable_s3_policy = var.enable_task_role && (
    length(var.s3_bucket_arns) > 0 || length(var.s3_object_arns) > 0
  )
  enable_rds_policy = var.enable_task_role && length(var.rds_db_resource_arns) > 0
}

