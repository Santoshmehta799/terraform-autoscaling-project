
resource "aws_autoscaling_group" "my_asg" {
  name                = "terraform-practice-asg"
  min_size            = 2
  max_size            = 4
  desired_capacity    = 2
  vpc_zone_identifier = data.aws_subnets.default.ids

  target_group_arns = [
    aws_lb_target_group.my_tg.arn
  ]

  launch_template {
    id      = aws_launch_template.my_template.id
    version = "$Latest"
  }

  health_check_type         = "ELB"
  health_check_grace_period = 300

  tag {
    key                 = "Name"
    value               = "Terraform-ASG-EC2"
    propagate_at_launch = true
  }
}



resource "aws_autoscaling_policy" "cpu_scaling" {
  name                   = "terraform-cpu-target-tracking"
  policy_type            = "TargetTrackingScaling"
  autoscaling_group_name = aws_autoscaling_group.my_asg.name

  estimated_instance_warmup = 180

  target_tracking_configuration {
    predefined_metric_specification {
      predefined_metric_type = "ASGAverageCPUUtilization"
    }

    target_value = 50.0
  }
}