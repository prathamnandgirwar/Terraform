variable "vpc_cidr_block" {
    type = string
    description = "value for vpc cidr"
}

variable "aws_subnet2" {
   type = list(string) 
description = "value of subnet"
}

variable "az" {
    type = list(string) 
  description = "specify avalibility zone"
}

variable "public_ip" {
    type = bool 
  description = "public ip value"
}

variable "port_no" {
    type = list(number)
description = "port number value"
}

variable "ami_id" {
    type = string 
description = "value of ami id"
  
}
variable "instance_type" {
    type = string 
description = "value for the instance type"
  
}

