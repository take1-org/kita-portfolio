# ---------------------------------------------
# variables ecs log-group
# ---------------------------------------------
variable "enable_ecs_log_group" {
  type    = bool
  default = true
}
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
