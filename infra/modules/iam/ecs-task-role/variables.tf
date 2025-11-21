# ---------------------------------------------
# variables for ecs task role
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

variable "enable_task_role" {
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


variable "s3_bucket_arns" {
  type    = list(string)
  default = []
}

variable "s3_object_arns" {
  type    = list(string)
  default = []
}

variable "rds_db_resource_arns" {
  type    = list(string)
  default = []
}

variable "enable_ssm_policy" {
  description = "Attach SSM Parameter Store read policy"
  type        = bool
  default     = true
}

variable "enable_secrets_policy" {
  description = "Attach Secrets Manager read policy"
  type        = bool
  default     = true
}

variable "enable_s3_policy" {
  description = "Attach S3 access policy"
  type        = bool
  default     = true
}

variable "enable_rds_policy" {
  description = "Attach RDS IAM authentication policy"
  type        = bool
  default     = true
}

variable "enable_ecs_exec" {
  description = "Attach minimal permissions for ECS Exec (ssmmessages channels)"
  type        = bool
  default     = true
}
