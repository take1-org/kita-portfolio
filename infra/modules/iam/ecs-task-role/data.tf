# ---------------------------------------------
# data for ecs task role 
# ---------------------------------------------
data "aws_iam_policy_document" "trust" {

  statement {
    actions = ["sts:AssumeRole"]

    principals {
      type        = "Service"
      identifiers = ["ecs-tasks.amazonaws.com"]
    }
  }
}

# SSM Parameter Store 読み取り（実行時にアプリが読む場合）
data "aws_iam_policy_document" "ssm_read" {
  dynamic "statement" {
    for_each = length(var.ssm_parameter_arns) > 0 ? [1] : []
    content {
      sid       = "SSMRead"
      actions   = ["ssm:GetParameter", "ssm:GetParameters", "ssm:GetParametersByPath"]
      resources = var.ssm_parameter_arns
    }
  }
}

data "aws_iam_policy_document" "secrets_read" {
  dynamic "statement" {
    for_each = length(var.secretsmanager_arns) > 0 ? [1] : []
    content {
      sid       = "SecretsRead"
      actions   = ["secretsmanager:GetSecretValue"]
      resources = var.secretsmanager_arns
    }
  }
}

data "aws_iam_policy_document" "s3_access" {
  # ListBucket はバケット ARN
  dynamic "statement" {
    for_each = length(var.s3_bucket_arns) > 0 ? [1] : []
    content {
      sid       = "S3ListBucket"
      actions   = ["s3:ListBucket"]
      resources = var.s3_bucket_arns
    }
  }
  # Get/Put はオブジェクト ARN（例: arn:aws:s3:::bucket/prefix/*）
  dynamic "statement" {
    for_each = length(var.s3_object_arns) > 0 ? [1] : []
    content {
      sid       = "S3ObjectRW"
      actions   = ["s3:GetObject", "s3:PutObject", "s3:AbortMultipartUpload", "s3:ListMultipartUploadParts"]
      resources = var.s3_object_arns
    }
  }
}

# RDS IAM 認証（使う場合のみ）
data "aws_iam_policy_document" "rds_connect" {
  dynamic "statement" {
    for_each = length(var.rds_db_resource_arns) > 0 ? [1] : []
    content {
      sid       = "RdsDbConnect"
      actions   = ["rds-db:connect"]
      resources = var.rds_db_resource_arns
    }
  }
}
# ECS Exec 用（ssmmessages の4アクション）
data "aws_iam_policy_document" "ecs_exec_ssmmessages" {
  statement {
    sid    = "AllowEcsExecChannels"
    effect = "Allow"
    actions = [
      "ssmmessages:CreateControlChannel",
      "ssmmessages:CreateDataChannel",
      "ssmmessages:OpenControlChannel",
      "ssmmessages:OpenDataChannel"
    ]
    resources = ["*"]
  }
}
