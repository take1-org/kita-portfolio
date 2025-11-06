# ---------------------------------------------
# security group for vpc endpoints
# ---------------------------------------------
# upate 2025.11.4
resource "aws_security_group" "this" {
  count       = var.enable_endpoints ? 1 : 0
  name        = "${var.name_prefix}-vpce-sg"
  description = "SG for VPC Interface Endpoints (ECS/ECR/Logs/SSM)"
  vpc_id      = var.vpc_id

  tags = merge(
    var.common_tags,
    {
      Name = "${var.name_prefix}-vpce-sg"
    },
    var.tags,
  )
}


resource "aws_vpc_security_group_ingress_rule" "ingress" {
  count                        = var.enable_endpoints ? 1 : 0
  security_group_id            = aws_security_group.this[0].id
  referenced_security_group_id = var.ecs_tasks_sg_id
  ip_protocol                  = "tcp"
  from_port                    = 443
  to_port                      = 443
}


resource "aws_vpc_security_group_egress_rule" "egress" {
  count             = var.enable_endpoints ? 1 : 0
  security_group_id = aws_security_group.this[0].id
  ip_protocol       = "-1"
  cidr_ipv4         = "0.0.0.0/0"
}

