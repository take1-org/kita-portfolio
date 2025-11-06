# ---------------------------------------------
# alb for app-ecs
# ---------------------------------------------
resource "aws_lb" "this" {
  count              = var.enable_alb ? 1 : 0
  name               = "${var.name_prefix}-alb"
  internal           = false
  load_balancer_type = "application"
  security_groups = [
    aws_security_group.alb[0].id
  ]
  subnets = var.public_subnet_ids

  idle_timeout = 60

  tags = merge(
    var.common_tags,
    {
      Name = "${var.name_prefix}-alb"
    },
    var.tags,
  )
}
