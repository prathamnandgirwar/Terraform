output "public_ip" {
  
  value = aws_instance.apache.public_ip
}
