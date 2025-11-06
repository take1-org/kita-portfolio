# ---------------------------------------------
# variables for ecs endpoints
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

/* variable "vpc_cidr" {
  type = string
} */

variable "vpc_cidr_block" {
  type = string
}

variable "vpc_id" {
  type    = string
  default = ""
}

variable "region" {
  type    = string
  default = "us-east-1"
}

variable "private_route_table_ids" {
  type        = list(string)
  description = "Route table IDs to associate with the S3 Gateway Endpoint"
  default     = []
}

variable "subnet_ids" {
  type        = list(string)
  description = "List of subnet IDs for the VPC endpoint"
  default     = []
}

variable "remote_subnet_1a" {
  type    = string
  default = ""
}

variable "ecs_tasks_sg_id" {
  type        = string
  description = "ECS tasks security group ID (source for VPCE ingress)"
}


variable "enable_endpoints" {
  type    = bool
  default = true
}

variable "enable_ecs_endpoints" { //このエンドポイントは、ecs/fargateでは、不要
  type    = bool
  default = false
}

variable "enable_ecr_endpoints" {
  type    = bool
  default = true
}

variable "enable_logs_endpoints" {
  type    = bool
  default = true
}

variable "enable_exec_endpoints" {
  type    = bool
  default = true
}

