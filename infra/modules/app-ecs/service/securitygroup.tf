# ---------------------------------------------
# security group for app-ecs-service
# ---------------------------------------------

#ecs task sg
resource "aws_security_group" "this" {
  count  = var.enable_ecs_service ? 1 : 0
  name   = "${var.name_prefix}-ecs-tasg-sg"
  vpc_id = var.vpc_id

  tags = merge(
    var.common_tags,
    {
      Name = "${var.name_prefix}-ecs-task-sg"
    },
    var.tags,
  )
}

# Tasks 80番は ALB SG からのみ許可
resource "aws_vpc_security_group_ingress_rule" "ecs_tasks_ingress" {
  count                        = var.enable_ecs_service ? 1 : 0
  security_group_id            = aws_security_group.this[0].id
  referenced_security_group_id = var.alb_sg_id # Tasks 80番は ALB SG からのみ許可
  from_port                    = 80
  to_port                      = 80
  ip_protocol                  = "tcp"
}
resource "aws_vpc_security_group_egress_rule" "tasks_all_egress" {
  count             = var.enable_ecs_service ? 1 : 0
  security_group_id = aws_security_group.this[0].id
  ip_protocol       = "-1"
  cidr_ipv4         = "0.0.0.0/0"
}
