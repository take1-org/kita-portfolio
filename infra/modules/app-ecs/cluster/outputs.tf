# ---------------------------------------------
# output for ecs cluster
# ---------------------------------------------
output "cluster_arn" {
  value = try(one(aws_ecs_cluster.this[*].arn), null)
}

output "cluster_name" {
  value = try(one(aws_ecs_cluster.this[*].name), null)
}
