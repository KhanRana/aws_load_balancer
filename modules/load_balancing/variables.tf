variable "vpc_id" {
  type = string
}

variable "ec2_id" {
  type = list(string)
}

variable "subnets" {
  type = list(string)
}

variable "security_groups" {
  type = list(string)
}
