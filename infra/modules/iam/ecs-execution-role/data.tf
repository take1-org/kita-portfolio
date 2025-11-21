# ---------------------------------------------
# data ECS Task Execution Role 
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

# Parameter Store / Secrets Manager / KMS を必要に応じて付与
data "aws_iam_policy_document" "extra" {
  # SSM Parameter Store
  dynamic "statement" {
    for_each = length(var.ssm_parameter_arns) > 0 ? [1] : []
    content {
      sid       = "AllowReadSSMParameters"
      effect    = "Allow"
      actions   = ["ssm:GetParameter", "ssm:GetParameters", "ssm:GetParametersByPath"]
      resources = var.ssm_parameter_arns
    }
  }

  # Secrets Manager
  dynamic "statement" {
    for_each = length(var.secretsmanager_arns) > 0 ? [1] : []
    content {
      sid       = "AllowReadSecretsManager"
      effect    = "Allow"
      actions   = ["secretsmanager:GetSecretValue"]
      resources = var.secretsmanager_arns
    }
  }

  # KMS（SecureString / Secrets が CMK で暗号化されている場合）
  dynamic "statement" {
    for_each = length(var.kms_key_arns) > 0 ? [1] : []
    content {
      sid       = "AllowKmsDecryptForSecrets"
      effect    = "Allow"
      actions   = ["kms:Decrypt"]
      resources = var.kms_key_arns
    }
  }
}
