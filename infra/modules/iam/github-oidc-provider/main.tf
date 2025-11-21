# ---------------------------------------------
# github_oidc_provider/main.tf
# ---------------------------------------------
resource "aws_iam_openid_connect_provider" "this" {
  count          = var.enable_oidc_provider ? 1 : 0
  url            = var.gha_url
  client_id_list = var.gha_client_id_list
  tags = merge(
    var.common_tags,
    var.tags,
    {
      Name = "${var.name_prefix}-oidc-provider"
    }
  )
}

