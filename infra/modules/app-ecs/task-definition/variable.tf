# ---------------------------------------------
# variables for task-definition
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

variable "enable_task_definition" {
  type    = bool
  default = true
}

variable "enable_efs" {
  type    = bool
  default = false
  validation {
    condition = (
      var.enable_efs == false ||
      (var.efs_file_system_id != null && var.efs_access_point_id != null)
    )
    error_message = "enable_efs=true の場合、efs_file_system_id と efs_access_point_id の両方が必須です。"
  }
}

variable "family_prefix" {
  type    = string
  default = "take1-ecs-woocommerce-app"
}

variable "region" {
  description = "AWS region"
  type        = string
  default     = ""
}

variable "log_group_name" {
  description = "CloudWatch Logs log group name for ECS task"
  type        = string
  default     = ""
}

# FargateのCPU/Memoryは組合せ制約があるため、値は正当な組合せを渡すこと
# CPU: 256 | 512 | 1024 | 2048 | 4096
variable "task_cpu" {
  description = "Fargate CPU units (as string). e.g., 512"
  type        = string
  validation {
    condition     = contains(["256", "512", "1024", "2048", "4096"], var.task_cpu)
    error_message = "task_cpu must be one of 256, 512, 1024, 2048, 4096."
  }
}

# MemoryはCPUに応じた範囲にする（例: CPU512なら1024〜4096）
variable "task_memory" {
  description = "Fargate memory (MiB) as string. e.g., 1024"
  type        = string
}

variable "execution_role_arn" {
  type    = string
  default = ""
}
variable "task_role_arn" {
  type    = string
  default = ""
}
variable "php_image" {
  description = "ECR image for PHP-FPM"
  type        = string
}

variable "nginx_image" {
  description = "ECR image for Nginx"
  type        = string
}


variable "php_environment" {
  description = "Environment variables for php container"
  type = list(object({
    name  = string
    value = string
  }))
  default = []
}

variable "nginx_environment" {
  description = "Environment variables for nginx container"
  type = list(object({
    name  = string
    value = string
  }))
  default = []
}


# 既存に追記
variable "enable_nginx_healthcheck" {
  type    = bool
  default = true
}

variable "nginx_healthcheck" {
  type = object({
    command      = list(string) # ["CMD-SHELL", "curl -f http://localhost/ || exit 1"]
    interval     = number       # seconds
    timeout      = number       # seconds
    retries      = number
    start_period = number # seconds
  })
  default = {
    #command      = ["CMD-SHELL", "curl -f http://127.0.0.1/healthz || exit 1"]
    command      = ["CMD-SHELL", "curl -fsS --max-time 2 http://127.0.0.1/healthz || exit 1"]
    interval     = 10
    timeout      = 5
    retries      = 3
    start_period = 60
  }
}

# 任意：php-fpm の簡易ヘルスチェックを付けたい場合
variable "enable_php_healthcheck" {
  type    = bool
  default = true
}

variable "php_healthcheck" {
  type = object({
    command      = list(string)
    interval     = number
    timeout      = number
    retries      = number
    start_period = number
  })
  default = {
    # php-fpm のマスタープロセス生存を確認（TCP:9000ではなくプロセスで簡易チェック）
    "command" : [
      "CMD-SHELL",
      "SCRIPT_NAME=/ping SCRIPT_FILENAME=/ping REQUEST_URI=/ping REQUEST_METHOD=GET cgi-fcgi -bind -connect /run/php-fpm/php-fpm.sock | grep -q pong || exit 1"
    ],
    interval     = 10
    timeout      = 5
    retries      = 3
    start_period = 60
  }
}
variable "efs_file_system_id" {
  type     = string
  default  = null
  nullable = true
}
variable "efs_access_point_id" {
  type     = string
  default  = null
  nullable = true
}

variable "php_command" {
  type    = list(string)
  default = null
}
