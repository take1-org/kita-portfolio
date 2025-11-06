# ---------------------------------------------
# variables ecs log-group
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

variable "log_group_name" {
  type    = string
  default = ""
}

variable "retention_in_days" {
  type    = number
  default = 30
}

variable "enable_ecs_cluster" {
  type    = bool
  default = true
}

variable "enable_container_insights" {
  description = "Enable CloudWatch Container Insights for the ECS cluster"
  type        = bool
  default     = false
}

variable "enable_exec" {
  type        = bool
  default     = false
  description = "Enable ECS Exec configuration on cluster"
}

variable "enable_fargate_spot" {
  type        = bool
  default     = false
  description = "Register FARGATE_SPOT and set default strategy"
}

variable "exec_kms_key_arn" {
  type        = string
  default     = null
  description = "KMS key ARN for ECS Exec (optional)"
}
