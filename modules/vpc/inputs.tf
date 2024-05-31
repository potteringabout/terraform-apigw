variable "region" {
  type    = string
  default = "eu-west-2"
}

variable "vpc_cidr" {
  type    = string
  default = "10.0.0.0/22"
}
/*
variable "subnets" {
  type = map(object({
    size = number
  }))
}*/

variable "egress" {
  type    = bool
  default = false
}

variable "ingress" {
  type    = bool
  default = false
}
