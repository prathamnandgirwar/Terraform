terraform {
  backend "s3" {
    bucket = "tf-backend-bucket-1"
    key = "terraform.tfstate"
    region = "ap-south-1"
    profile = "pratham"
  }
}
