variable "AMI" {
    type = string
    default = "ami-0505148b3591e4c07"
}

variable "ec2_name" {
  type = list(string)
}

variable "instance_type" {
  type = string
  default = "t2.micro"
}

variable "subnet_id" {
  type = list(string)
}

variable "security_groups" {
  type = list(string)
}

variable "key_pair" {
  type = string
}
