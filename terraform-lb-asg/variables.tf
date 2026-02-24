variable "region" {
  default = "ap-south-1"
}

variable "azs" {
  default = ["ap-south-1a", "ap-south-1b"]
}

variable "ami_id" {
  description = "Amazon Linux 2 AMI ID"
}
