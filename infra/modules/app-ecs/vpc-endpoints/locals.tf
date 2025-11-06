# ---------------------------------------------
# Locals for app-ecs VPC endpoints
# ---------------------------------------------
# 必要サービスをトグルで組み立て
locals {
  ecs_services = var.enable_ecs_endpoints ? [
    "com.amazonaws.${var.region}.ecs",
    "com.amazonaws.${var.region}.ecs-telemetry"
  ] : []

  ecr_services = var.enable_ecr_endpoints ? [
    "com.amazonaws.${var.region}.ecr.api",
    "com.amazonaws.${var.region}.ecr.dkr"
  ] : []

  logs_services = var.enable_logs_endpoints ? [
    "com.amazonaws.${var.region}.logs"
  ] : []

  exec_services = var.enable_exec_endpoints ? [
    "com.amazonaws.${var.region}.ssm",
    "com.amazonaws.${var.region}.ssmmessages",
    # "com.amazonaws.${var.region}.ec2messages" #非推奨となった
  ] : []




  all_services = distinct(concat(local.ecs_services, local.ecr_services, local.logs_services, local.exec_services))
}
