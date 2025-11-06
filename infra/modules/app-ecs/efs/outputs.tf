# ---------------------------------------------
# outputs for efs
# ---------------------------------------------

output "efs_file_system_id" {
  value = try(one(aws_efs_file_system.this[*].id), null)
}
output "efs_access_point_id" {
  value = try(one(aws_efs_access_point.this[*].id), null)
}
output "efs_security_group_id" {
  value = try(one(aws_security_group.this[*].id), null)
}
