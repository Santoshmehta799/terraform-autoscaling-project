resource "aws_launch_template" "my_template" {
  name_prefix   = "terraform-asg-"
  image_id      = "ami-096ef200a877f36af"
  instance_type = "t3.micro"

  vpc_security_group_ids = [aws_security_group.ec2_sg.id]

  user_data = base64encode(<<-EOF
    #!/bin/bash
    dnf update -y
    dnf install -y httpd
    systemctl enable httpd
    systemctl start httpd
    echo "<h1>Hello from Terraform Auto Scaling</h1>" > /var/www/html/index.html
  EOF
  )
  tag_specifications {
    resource_type = "instance"
    tags = {
      Name = "Terraform-ASG-Instance"
    }
  }
}


