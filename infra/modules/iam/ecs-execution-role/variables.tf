# ---------------------------------------------
# variables for ecs task execution role
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

variable "region" {
  description = "AWS Region"
  type        = string
  default     = "us-east-1"
}

variable "enable_execution_role" {
  description = "Whether to create the ECS task execution role"
  type        = bool
  default     = true
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
