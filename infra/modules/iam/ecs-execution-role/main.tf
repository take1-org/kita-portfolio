# ---------------------------------------------
# ECS Task Execution Role 
# ---------------------------------------------
resource "aws_iam_role" "this" {
  count              = var.enable_execution_role ? 1 : 0
  name               = "${var.name_prefix}-execution-role"
  assume_role_policy = data.aws_iam_policy_document.trust.json

  tags = merge(
    var.common_tags,
    {
      Name        = "${var.name_prefix}-execution-role"
      Environment = var.env
      Component   = "ecs"
    },
    var.tags,
  )
}

# ベース: ECR Pull / CloudWatch Logs など必須
resource "aws_iam_role_policy_attachment" "base" {
  count      = var.enable_execution_role ? 1 : 0
  role       = aws_iam_role.this[0].name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonECSTaskExecutionRolePolicy"
}

# 追加権限（必要がある時だけ作る：SSM / Secrets / KMS）
resource "aws_iam_policy" "extra" {
  count       = var.enable_execution_role && length(compact([for s in data.aws_iam_policy_document.extra.statement : s.sid])) > 0 ? 1 : 0
  name        = "${var.name_prefix}-execution-extra"
  description = "Extra permissions for ECS execution role (read SSM/Secrets/KMS decrypt as needed)"
  policy      = data.aws_iam_policy_document.extra.json
}

resource "aws_iam_role_policy_attachment" "extra_attach" {
  count      = length(aws_iam_policy.extra) > 0 ? 1 : 0
  role       = aws_iam_role.this[0].name
  policy_arn = aws_iam_policy.extra[0].arn
}
