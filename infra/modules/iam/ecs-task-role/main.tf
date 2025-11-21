# ---------------------------------------------
# ecs task role
# ---------------------------------------------

resource "aws_iam_role" "this" {
  count              = var.enable_task_role ? 1 : 0
  name               = "${var.name_prefix}-task-role"
  assume_role_policy = data.aws_iam_policy_document.trust.json

  tags = merge(
    var.common_tags,
    {
      Name        = "${var.name_prefix}-task-role"
      Environment = var.env
      Component   = "ecs"
    },
    var.tags,
  )
}

# SSM 読み取り
resource "aws_iam_policy" "ssm_read" {
  count  = local.enable_ssm_policy ? 1 : 0
  name   = "${var.name_prefix}-ecs-task-ssm-read"
  policy = data.aws_iam_policy_document.ssm_read.json
}
resource "aws_iam_role_policy_attachment" "ssm_read" {
  count      = local.enable_ssm_policy ? 1 : 0
  role       = aws_iam_role.this[0].name
  policy_arn = aws_iam_policy.ssm_read[0].arn
}

# Secrets 読み取り
resource "aws_iam_policy" "secrets_read" {
  count  = local.enable_secrets_policy ? 1 : 0
  name   = "${var.name_prefix}-ecs-task-secrets-read"
  policy = data.aws_iam_policy_document.secrets_read.json
}
resource "aws_iam_role_policy_attachment" "secrets_read" {
  count      = local.enable_secrets_policy ? 1 : 0
  role       = aws_iam_role.this[0].name
  policy_arn = aws_iam_policy.secrets_read[0].arn
}

# S3 アクセス
resource "aws_iam_policy" "s3_access" {
  count  = local.enable_s3_policy ? 1 : 0
  name   = "${var.name_prefix}-ecs-task-s3"
  policy = data.aws_iam_policy_document.s3_access.json
}
resource "aws_iam_role_policy_attachment" "s3_access" {
  count      = local.enable_s3_policy ? 1 : 0
  role       = aws_iam_role.this[0].name
  policy_arn = aws_iam_policy.s3_access[0].arn
}

# RDS IAM 認証
resource "aws_iam_policy" "rds_connect" {
  count  = local.enable_rds_policy ? 1 : 0
  name   = "${var.name_prefix}-ecs-task-rds-connect"
  policy = data.aws_iam_policy_document.rds_connect.json
}
resource "aws_iam_role_policy_attachment" "rds_connect" {
  count      = local.enable_rds_policy ? 1 : 0
  role       = aws_iam_role.this[0].name
  policy_arn = aws_iam_policy.rds_connect[0].arn
}

resource "aws_iam_policy" "ecs_exec_ssmmessages" {
  count  = var.enable_task_role && var.enable_ecs_exec ? 1 : 0
  name   = "${var.name_prefix}-ecs-exec-ssmmessages"
  policy = data.aws_iam_policy_document.ecs_exec_ssmmessages.json
}

resource "aws_iam_role_policy_attachment" "ecs_exec_ssmmessages" {
  count      = var.enable_task_role && var.enable_ecs_exec ? 1 : 0
  role       = aws_iam_role.this[0].name
  policy_arn = aws_iam_policy.ecs_exec_ssmmessages[0].arn
}
