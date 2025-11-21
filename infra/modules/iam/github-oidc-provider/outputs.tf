# ---------------------------------------------
# Outputs
# ---------------------------------------------

output "arn" {
  description = "ARN of the GitHub OIDC provider"
  #value       = aws_iam_openid_connect_provider.this[0].arn
  value = var.enable_oidc_provider ? one(aws_iam_openid_connect_provider.this[*].arn) : null
}




output "url" {
  description = "URL of the OIDC provider"
  #value       = aws_iam_openid_connect_provider.this[0].url
  value = var.enable_oidc_provider ? one(aws_iam_openid_connect_provider.this[*].url) : null
}
