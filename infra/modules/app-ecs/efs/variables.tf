# ---------------------------------------------
# varables for EFS
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

variable "enable_efs" {
  type    = bool
  default = true
}

variable "vpc_id" {
  description = "VPC ID where EFS will be created"
  type        = string
}

variable "subnet_id" {
  description = "EFS Mount Target を作成する 1AZ のサブネット"
  type        = string
}

variable "ecs_tasks_sg_id" {
  description = "Security Group ID of ECS tasks that will access EFS"
  type        = string
}


variable "posix_uid" {
  description = "POSIX User ID for EFS Access Point"
  type        = number
  default     = 1000
}
variable "posix_gid" {
  description = "POSIX Group ID for EFS Access Point"
  type        = number
  default     = 1000
}
variable "ap_root_dir" {
  description = "EFS Access Point のルート（実運用は /wp-content 固定）"
  type        = string
  default     = "/wp-content"
}
