# ---------------------------------------------
# target group for app-ecs
# ---------------------------------------------

resource "aws_lb_target_group" "this" {
  count       = var.enable_tg ? var.tg_count : 0
  name        = format("%s-web-tg-%02d", var.name_prefix, count.index + 1)
  vpc_id      = var.vpc_id
  port        = 80
  protocol    = "HTTP"
  target_type = "ip"


  stickiness { #本番運用では、redisへ置き換える
    enabled         = var.enable_stickiness
    type            = "lb_cookie"
    cookie_duration = var.tg_sticky_cookie_seconds
  }

  deregistration_delay = var.tg_deregistration_delay

  health_check {
    path                = var.tg_health_path
    matcher             = var.tg_health_matcher # e.g. "200-399"
    interval            = var.tg_hc_interval
    timeout             = var.tg_hc_timeout
    healthy_threshold   = var.tg_hc_healthy
    unhealthy_threshold = var.tg_hc_unhealthy
  }
  lifecycle {
    # create_before_destroy = true
    prevent_destroy = true
  }

  tags = merge(var.tags, {
    Name = format("%s-web-tg-%02d", var.name_prefix, count.index + 1)
  })
}
