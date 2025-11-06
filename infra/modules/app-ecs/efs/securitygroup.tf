# ---------------------------------------------
# security group for efs
# ---------------------------------------------
resource "aws_security_group" "this" {
  count       = var.enable_efs ? 1 : 0
  name        = "${var.name_prefix}-efs-sg"
  description = "EFS mount targets"
  vpc_id      = var.vpc_id
  tags        = merge(var.tags, { Name = "${var.name_prefix}-efs-sg" })
}

# IN/OUT（明示）
resource "aws_vpc_security_group_ingress_rule" "this" {
  count                        = var.enable_efs ? 1 : 0
  security_group_id            = aws_security_group.this[0].id
  description                  = "NFS from ECS tasks SG"
  ip_protocol                  = "tcp"
  from_port                    = 2049
  to_port                      = 2049
  referenced_security_group_id = var.ecs_tasks_sg_id
}

resource "aws_vpc_security_group_egress_rule" "this" {
  count             = var.enable_efs ? 1 : 0
  security_group_id = aws_security_group.this[0].id
  ip_protocol       = "-1"
  cidr_ipv4         = "0.0.0.0/0"
}
