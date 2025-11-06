# ---------------------------------------------
# variables (app-ecs)
# ---------------------------------------------
variable "project" {
  description = "take1 ecs woocommerce project name"
  type        = string
}

variable "env" {
  type    = string
  default = "dev"
}

variable "region" {
  type    = string
  default = "us-east-1"
}

variable "common_tags" {
  type        = map(string)
  description = "common tags for all resources"
  default     = {}
}

variable "tags" {
  type    = map(string)
  default = {}
}

variable "retention_in_days" {
  type        = number
  description = "The number of days to retain log events in the specified log group."
  default     = 1
}

# Remote state (foundations) location
variable "remote_state_bucket" {
  type = string
}
variable "remote_state_key" {
  type = string
}
variable "remote_state_region" {
  type = string
}

variable "family_prefix" {
  type    = string
  default = "take1-ecs-woocommerce-app"
}

variable "task_cpu" {
  description = "Fargate CPU units (as string). e.g., 512"
  type        = string
  validation {
    condition     = contains(["256", "512", "1024", "2048", "4096"], var.task_cpu)
    error_message = "task_cpu must be one of 256, 512, 1024, 2048, 4096."
  }
}
variable "task_memory" {
  description = "Fargate memory (MiB) as string. e.g., 1024"
  type        = string
}

variable "ecs_execution_role_arn" {
  type    = string
  default = ""
}

variable "ecs_task_role_arn" {
  type    = string
  default = ""
}


variable "log_group_name" {
  type    = string
  default = ""
}

variable "php_image" {
  type    = string
  default = "public.ecr.aws/docker/library/php:8.0-fpm"
}

variable "nginx_image" {
  type    = string
  default = "public.ecr.aws/nginx/nginx:latest"
}

variable "php_environment" {
  type    = list(map(string))
  default = []
}
variable "nginx_environment" {
  type    = list(map(string))
  default = []
}
variable "enable_container_insights" {
  type    = bool
  default = false
}

variable "ecs_tasks_sg_id" {
  description = "ECSタスクのSG（EFSがこのSGからの2049を受ける）"
  type        = string
  default     = ""
}

variable "efs_access_point_id" {
  type    = string
  default = ""
}

variable "efs_file_system_id" {
  type    = string
  default = ""
}

variable "desired_count" {
  type    = number
  default = 0
}


# ★ 以下は「外部から渡さない」ので variable にしない（localsで受ける）
# - vpc_cidr_block
# - private_subnet_ids
# - private_subnet_azs
# - remote_subnet_1a など


