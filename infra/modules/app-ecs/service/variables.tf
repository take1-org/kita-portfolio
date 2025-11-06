# ---------------------------------------------
# variables for app-ecs service
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

variable "enable_ecs_service" {
  type    = bool
  default = true
}

variable "vpc_id" {
  description = "VPC ID where EFS will be created"
  type        = string
  default     = ""
}

variable "cluster" {
  type    = string
  default = ""
}
variable "cluster_arn" {
  type    = string
  default = ""
}

variable "task_definition" {
  type    = string
  default = ""
}
variable "task_definition_arn" {
  type    = string
  default = ""
  # 例: arn:aws:ecs:us-east-1:123456789012:task-definition/take1-ecs-dev-woocommerce:42
}

variable "private_subnet_ids" {
  type    = list(string)
  default = []
}

variable "desired_count" {
  type    = number
  default = 1
}

variable "alb_sg_id" {
  type        = string
  description = "Security group ID of ALB (for ECS tasks inbound 80)"
  default     = ""
}

variable "target_group_arn" {
  type        = string
  description = "ARN of ALB target group"
  default     = ""
}
