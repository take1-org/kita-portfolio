# ---------------------------------------------
# variables.tf
# ---------------------------------------------
variable "name_prefix" {
  type = string
}

variable "tags" {
  type    = map(string)
  default = {}
}
variable "common_tags" {
  type        = map(string)
  description = "take1-dev-ecs"
}
variable "project" {
  type    = string
  default = ""
}
variable "env" {
  type    = string
  default = ""
}

variable "enable_oidc_provider" {
  description = "Whether to create the GitHub OIDC provider"
  type        = bool
  default     = true
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


variable "region" {
  description = "AWS Region"
  type        = string
  default     = "us-east-1"
}
variable "repo" {
  description = "GitHub repository name"
  type        = string
  default     = ""
}

variable "owner" {
  description = "GitHub organization or user name"
  type        = string
  default     = ""
}

variable "allowed_refs" {
  description = "GitHub repository refs allowed to assume the role"
  type        = list(string)
  default     = []
}
