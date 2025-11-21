# ---------------------------------------------
# Locals
# ---------------------------------------------
locals {
  name_prefix = "${var.project}-${var.env}"
  ssm_parameter_arns = [
    "arn:aws:ssm:${var.region}:${var.account_id}:parameter/take1-ecs/dev/db/*"
  ]
  secretsmanager_arns = [
    "arn:aws:secretsmanager:${var.region}:${var.account_id}:secret:take1-ecs/dev/*"
  ]
  s3_bucket_arns = [
    "arn:aws:s3:::take1-ecs-dev-bucket" #["arn:aws:s3:::take1-ecs-dev-media"]
  ]
  s3_object_arns = [
    "arn:aws:s3:::take1-ecs-dev-bucket/*"
  ]
}
