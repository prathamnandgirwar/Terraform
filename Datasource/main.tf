data "aws_ami" "image" {
  most_recent      = true
  owners           = ["564516608959"]

  filter {
    name   = "name"
    values = ["Ubuntu_22.04-x86_64-SQL_2022_Standard-2024.05.30"]
  }

  filter {
    name   = "root-device-type"
    values = ["ebs"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }
}

resource "aws_instance" "web" {
    ami = data.aws_ami.image.id
    instance_type = "t2.micro"
}

output "ami_value" {
    value = aws_instance.web.id

}
resource "aws_s3_bucket" "test" {
    bucket = "pratham-b39-bucket"
  
}
