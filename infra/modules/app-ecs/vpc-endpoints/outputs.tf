# ---------------------------------------------
# outputs for VPC Endpoints Module
# ---------------------------------------------
output "security_group_id" {
  value = try(one(aws_security_group.this[*].id), null)
}

output "endpoint_ids" {
  value = { for k, v in aws_vpc_endpoint.this : k => v.id }
}
