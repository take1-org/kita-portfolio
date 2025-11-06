# ---------------------------------------------
# vpc-endpoint for ecs
# ---------------------------------------------
resource "aws_vpc_endpoint" "this" {
  for_each            = var.enable_endpoints ? toset(local.all_services) : toset([])
  vpc_id              = var.vpc_id
  service_name        = each.value
  vpc_endpoint_type   = "Interface"
  private_dns_enabled = true
  subnet_ids          = var.subnet_ids
  security_group_ids  = [aws_security_group.this[0].id]

  # 必要に応じてアクセス制御を厳密化（省略時 = デフォルト許可）
  # policy = jsonencode({
  #   Version = "2012-10-17",
  #   Statement = [{
  #     Effect   = "Allow",
  #     Principal= "*",
  #     Action   = "*",
  #     Resource = "*"
  #   }]
  # })

  tags = merge(
    var.common_tags,
    { Name = "${var.name_prefix}-vpce-${replace(each.value, "com.amazonaws.${var.region}.", "")}" },
    var.tags
  )
}
