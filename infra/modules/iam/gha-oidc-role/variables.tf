# ---------------------------------------------
# variables.tf
# ---------------------------------------------

variable "name_prefix" {
  type = string
}

variable "tags" {
  type = map(string)
}
variable "common_tags" {
  type        = map(string)
  description = "take1-dev-ecs"
}

# variable "project" {
#   type = string
# }
variable "env" {
  type = string
}

variable "enable_oidc_role" {
  description = "Whether to create the GitHub OIDC role"
  type        = bool
  default     = true
}

variable "gha_url" {
  description = "GitHub Actions OIDC Provider URL"
  type        = string

}

variable "gha_client_id_list" {
  description = "GitHub Actions OIDC Client ID"
  type        = list(string)

}

# ---------------------------------------------
# GitHub OIDC Role Module
# ---------------------------------------------

variable "role_name" {
  description = "IAM Role name for GitHub Actions OIDC"
  type        = string
}

variable "oidc_provider_arn" {
  description = "ARN of the GitHub OIDC provider"
  type        = string
}

variable "github_repo" {
  description = "GitHub repository name"
  type        = string
  default     = ""
}

variable "github_owner" {
  description = "GitHub organization or user name"
  type        = string
  default     = ""
}


variable "ecr_repo_nginx" {
  description = "ecr repository name"
  type        = string
  default     = ""
}

variable "ecr_repo_php" {
  description = "ecr repository name"
  type        = string
  default     = ""
}

variable "allowed_refs" {
  description = "List of allowed GitHub refs (e.g., refs/heads/main)"
  type        = list(string)
}

variable "region" {
  description = "AWS Region"
  type        = string
  default     = "us-east-1"
}


variable "managed_policy_arns" {
  description = "List of managed policy ARNs to attach"
  type        = list(string)
  default     = []
}

variable "inline_policies_json" {
  description = "List of JSON strings representing inline policies"
  type        = list(string)
  default     = []
}




