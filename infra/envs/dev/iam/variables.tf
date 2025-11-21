# ---------------------------------------------
# variables.tf
# ---------------------------------------------
variable "tags" {
  type    = map(string)
  default = {}
}
variable "common_tags" {
  type        = map(string)
  description = "common tags for all resources"
  default     = {}
}

variable "project" {
  description = "take1 ecs woocomerce project name"
  type        = string
  default     = ""
}
variable "name_prefix" {
  type    = string
  default = ""
}
variable "env" {
  type    = string
  default = "dev"
}

variable "account_id" {
  description = "AWS Account ID"
  type        = string
  default     = ""
}

variable "region" {
  description = "AWS Region"
  type        = string
  default     = "us-east-1"
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
  description = "GitHub repository refs allowed to assume the role"
  type        = list(string)
  default     = []
}


variable "gha_url" {
  description = "GitHub Actions OIDC Provider URL"
  type        = string
  default     = ""
}
variable "gha_client_id_list" {
  description = "GitHub Actions OIDC Client ID"
  type        = list(string)
  default     = [""]
}

variable "ssm_parameter_arns" {
  type    = list(string)
  default = []
}

variable "secretsmanager_arns" {
  type    = list(string)
  default = []
}

variable "kms_key_arns" {
  type    = list(string)
  default = []
}

variable "s3_bucket_arns" {
  type    = list(string)
  default = []
}

variable "s3_object_arns" {
  type    = list(string)
  default = []
}
