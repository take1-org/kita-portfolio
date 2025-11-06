# ---------------------------------------------
# security group for alb app-ecs
# ---------------------------------------------

resource "aws_security_group" "alb" {
  count  = var.enable_alb ? 1 : 0
  name   = "${var.name_prefix}-alb-sg"
  vpc_id = var.vpc_id

  tags = merge(
    var.common_tags,
    {
      Name = "${var.name_prefix}-alb-sg"
    },
    var.tags,
  )
}

resource "aws_vpc_security_group_ingress_rule" "alb_http" {
  count             = var.enable_alb ? 1 : 0
  security_group_id = aws_security_group.alb[0].id
  cidr_ipv4         = "0.0.0.0/0"
  ip_protocol       = "tcp"
  from_port         = 80
  to_port           = 80
}

resource "aws_vpc_security_group_ingress_rule" "alb_https" {
  count             = var.enable_alb ? 1 : 0
  security_group_id = aws_security_group.alb[0].id
  cidr_ipv4         = "0.0.0.0/0"
  ip_protocol       = "tcp"
  from_port         = 443
  to_port           = 443
}

resource "aws_vpc_security_group_egress_rule" "alb_all" {
  count             = var.enable_alb ? 1 : 0
  security_group_id = aws_security_group.alb[0].id
  ip_protocol       = "-1"
  cidr_ipv4         = "0.0.0.0/0"
}

