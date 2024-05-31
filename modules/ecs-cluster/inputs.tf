variable "cluster_name" {
  type        = string
  description = "Name of ECS cluster"
}

variable "cluster_log_group_name" {
  type        = string
  description = "ECS cluster log group"
}

variable "cluster_execution_encryption_key_arn" {
  type        = string
  description = "ECS execution encryption key arn"
}
