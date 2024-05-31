variable "subnet_ids" {
  type = list(string)
}

variable "vpc_id" {
  type = string
}

variable "lb" {
  type = object({
    name = string
  })
}

variable "target_group" {
  type = object({
    name = string
    port = number
  })
}

variable "ingress_ips" {
  type = list(string)
}
