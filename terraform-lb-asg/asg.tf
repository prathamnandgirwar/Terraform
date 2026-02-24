resource "aws_launch_template" "lt" {
  image_id      = var.ami_id
  instance_type = "t2.micro"

  user_data = base64encode(<<EOF
#!/bin/bash
yum install -y httpd
echo "Hello from Auto Scaling" > /var/www/html/index.html
systemctl start httpd
systemctl enable httpd
EOF
  )

  network_interfaces {
    associate_public_ip_address = true
    security_groups             = [aws_security_group.web_sg.id]
  }
}

resource "aws_autoscaling_group" "asg" {
  min_size            = 1
  max_size            = 4
  desired_capacity    = 2
  vpc_zone_identifier = aws_subnet.public[*].id
  target_group_arns  = [aws_lb_target_group.tg.arn]

  launch_template {
    id      = aws_launch_template.lt.id
    version = "$Latest"
  }
}
