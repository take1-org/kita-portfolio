# ---------------------------------------------
# oidc
# ---------------------------------------------


# ---------------------------------------------
# IAM Role for GitHub Actions (OIDC)
# ---------------------------------------------
resource "aws_iam_role" "this" {
  count              = var.enable_oidc_role ? 1 : 0
  name               = var.role_name
  assume_role_policy = data.aws_iam_policy_document.assume_role_policy.json
  tags = merge(
    var.common_tags,
    {
      Name        = "${var.name_prefix}-iam-role"
      Environment = var.env
    },
    var.tags,
  )
}

# ---------------------------------------------
# Inline policies
# ---------------------------------------------
resource "aws_iam_role_policy" "inline" {
  for_each = { for idx, p in var.inline_policies_json : idx => p }

  name   = "${var.role_name}-inline-${each.key}"
  role   = aws_iam_role.this[0].id
  policy = each.value

}

# ---------------------------------------------
# Managed policies (optional attach)
# ---------------------------------------------
resource "aws_iam_role_policy_attachment" "managed" {
  for_each = toset(var.managed_policy_arns)

  role       = aws_iam_role.this[0].name
  policy_arn = each.value
}
