variable "ecr_name" {
  description = "Name of ECR"
  type        = string
}

variable "mutability" {
  description = "Immutable image tags"
  default     = "IMMUTABLE"
  type        = string
}

variable "kms_key" {
  description = "KMS Key ARN for ECR encryption"
  type        = string
}
