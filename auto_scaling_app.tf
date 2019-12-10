# auto_scaling.tf

resource "aws_launch_template" "app_tier" {
  name_prefix = "app"
  image_id    = "ami-0c5204531f799e0c6"
  # Should be a1.large, but this all for testing and demo
  instance_type          = "t2.micro"
  vpc_security_group_ids = [aws_security_group.app_layer_security_group.id]

}

resource "aws_autoscaling_group" "app_auto_scaling" {
  desired_capacity          = 4
  max_size                  = 6
  min_size                  = 2
  health_check_grace_period = 300
  health_check_type         = "EC2"
  force_delete              = true
  vpc_zone_identifier       = [aws_subnet.us-west-2a-private-app.id, aws_subnet.us-west-2a-private-app.id]

  target_group_arns = [aws_alb_target_group.app.id]


  launch_template {
    id      = "${aws_launch_template.app_tier.id}"
    version = "$Latest"
  }

  tag {
    key                 = "Name"
    value               = "app-tier"
    propagate_at_launch = true
  }
}

resource "aws_autoscaling_policy" "app-tier-scale-up" {
  name                   = "app-tier-scale-up"
  scaling_adjustment     = 1
  adjustment_type        = "ChangeInCapacity"
  cooldown               = 60
  autoscaling_group_name = "${aws_autoscaling_group.app_auto_scaling.name}"
}

resource "aws_autoscaling_policy" "app-tier-scale-down" {
  name                   = "app-tier-scale-down"
  scaling_adjustment     = -1
  adjustment_type        = "ChangeInCapacity"
  cooldown               = 60
  autoscaling_group_name = "${aws_autoscaling_group.app_auto_scaling.name}"
}

# CloudWatch alarm that triggers the autoscaling up policy
resource "aws_cloudwatch_metric_alarm" "app-tier_cpu_high" {
  alarm_name          = "app_tier_cpu_utilization_high"
  comparison_operator = "GreaterThanOrEqualToThreshold"
  evaluation_periods  = "2"
  metric_name         = "CPUUtilization"
  namespace           = "AWS/EC2"
  period              = "60"
  statistic           = "Average"
  threshold           = "75"

  alarm_actions = [
    "${aws_autoscaling_policy.app-tier-scale-up.arn}"
  ]
  dimensions = {
    AutoScalingGroupName = "${aws_autoscaling_group.app_auto_scaling.name}"
  }
}

# CloudWatch alarm that triggers the autoscaling up policy
resource "aws_cloudwatch_metric_alarm" "app-tier_memory_high" {
  alarm_name          = "app_tier_memory_utilization_high"
  comparison_operator = "GreaterThanOrEqualToThreshold"
  evaluation_periods  = "2"
  metric_name         = "MemoryUtilization"
  namespace           = "AWS/EC2"
  period              = "60"
  statistic           = "Average"
  threshold           = "80"

  alarm_actions = [
    "${aws_autoscaling_policy.app-tier-scale-up.arn}"
  ]
  dimensions = {
    AutoScalingGroupName = "${aws_autoscaling_group.app_auto_scaling.name}"
  }
}

# CloudWatch alarm that triggers the autoscaling up policy
resource "aws_cloudwatch_metric_alarm" "app-tier_cpu_low" {
  alarm_name          = "app_tier_cpu_utilization_low"
  comparison_operator = "GreaterThanOrEqualToThreshold"
  evaluation_periods  = "2"
  metric_name         = "CPUUtilization"
  namespace           = "AWS/EC2"
  period              = "60"
  statistic           = "Average"
  threshold           = "30"

  alarm_actions = [
    "${aws_autoscaling_policy.app-tier-scale-down.arn}"
  ]
  dimensions = {
    AutoScalingGroupName = "${aws_autoscaling_group.app_auto_scaling.name}"
  }
}

# CloudWatch alarm that triggers the autoscaling up policy
resource "aws_cloudwatch_metric_alarm" "app-tier_memory_low" {
  alarm_name          = "app_tier_memory_utilization_low"
  comparison_operator = "GreaterThanOrEqualToThreshold"
  evaluation_periods  = "2"
  metric_name         = "MemoryUtilization"
  namespace           = "AWS/EC2"
  period              = "60"
  statistic           = "Average"
  threshold           = "30"

  alarm_actions = [
    "${aws_autoscaling_policy.app-tier-scale-down.arn}"
  ]
  dimensions = {
    AutoScalingGroupName = "${aws_autoscaling_group.app_auto_scaling.name}"
  }
}

