# ---------------------------------------------
# outputs for alb&target group for app-ecs
# ---------------------------------------------
# one() + try() で単体/複数どちらにも対応
output "tg_arns" {
  value = aws_lb_target_group.this[*].arn
}

output "tg_arn" {
  value = try(one(aws_lb_target_group.this[*].arn), null)
}

output "tg_names" {
  value = try(one(aws_lb_target_group.this[*].name), null)
}

output "alb_sg_id" {
  value = try(one(aws_security_group.alb[*].id), null)
}

output "alb_dns_name" {
  value = try(one(aws_lb.this[*].dns_name), null)
}
