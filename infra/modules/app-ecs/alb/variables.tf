# ---------------------------------------------
# variables  for alb ecs
# ---------------------------------------------

variable "enable_tg" {
  type    = bool
  default = true
}

variable "enable_alb" {
  type    = bool
  default = true
}

variable "enable_tasks_sg" {
  type    = bool
  default = true
}

variable "enable_stickiness" {
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

variable "vpc_id" {
  type    = string
  default = ""
}

variable "tg_count" {
  type    = number
  default = 1
}

variable "tg_sticky_cookie_seconds" {
  type    = number
  default = 3600

}

variable "tg_deregistration_delay" {
  type    = number
  default = 30
}

variable "tg_health_path" {
  type    = string
  default = "/healthz"
}

variable "tg_health_matcher" {
  type    = string
  default = "200-399"
  # 説明: ターゲットグループのヘルスチェックで正常と見なすHTTPレスポンスコードの範囲。
}

variable "tg_hc_interval" {
  type    = number
  default = 30
  # 説明: ヘルスチェックの実行間隔（秒）。
}

variable "tg_hc_timeout" {
  type    = number
  default = 5
  # 説明: ヘルスチェックのリクエストがタイムアウトするまでの時間（秒）。
}

variable "tg_hc_healthy" {
  type    = number
  default = 2
  # 説明: ターゲットが正常と見なされるために必要な連続した成功ヘルスチェックの回数。
}

variable "tg_hc_unhealthy" {
  type    = number
  default = 2
  # 説明: ターゲットが異常と見なされるために必要な連続した失敗ヘルスチェックの回数。
}

variable "public_subnet_ids" {
  type    = list(string)
  default = []

}

variable "acm_certificate_arn" {
  type    = string
  default = ""

}

variable "default_target_group_arn" {
  type    = string
  default = ""
}
