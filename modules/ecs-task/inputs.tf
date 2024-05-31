variable "task_family" {
  description = "Task Family name"
  type        = string
}

variable "task_role_arn" {
  description = "Role ARN for task execution"
  type        = string
}

variable "execution_role_arn" {
  description = "Role ARN to allow the container agent access to AWS services, Eg. to pull image from ECR"
  type        = string
}

variable "container_definitions" {
  type = list(object({
    name         = string
    image        = string
    cpu          = number
    memory       = number
    essential    = bool
    portMappings = list(any)
  }))

}
