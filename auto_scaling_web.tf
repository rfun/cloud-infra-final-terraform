# auto_scaling.tf

resource "aws_launch_template" "web_tier" {
  name_prefix = "web"
  image_id    = "ami-0c5204531f799e0c6"
  # Should be a1.large, but this all for testing and demo
  instance_type          = "t2.micro"
  vpc_security_group_ids = [aws_security_group.web_layer_security_group.id]

}

resource "aws_autoscaling_group" "web_auto_scaling" {
  desired_capacity          = 4
  max_size                  = 6
  min_size                  = 2
  health_check_grace_period = 300
  health_check_type         = "EC2"
  force_delete              = true
  vpc_zone_identifier       = [aws_subnet.us-west-2a-private-web.id, aws_subnet.us-west-2a-private-web.id]

  target_group_arns = [aws_alb_target_group.web.id]

  launch_template {
    id      = "${aws_launch_template.web_tier.id}"
    version = "$Latest"
  }

  tag {
    key                 = "Name"
    value               = "web-tier"
    propagate_at_launch = true
  }
}

resource "aws_autoscaling_policy" "web-tier-scale-up" {
  name                   = "web-tier-scale-up"
  scaling_adjustment     = 1
  adjustment_type        = "ChangeInCapacity"
  cooldown               = 60
  autoscaling_group_name = "${aws_autoscaling_group.web_auto_scaling.name}"
}

resource "aws_autoscaling_policy" "web-tier-scale-down" {
  name                   = "web-tier-scale-down"
  scaling_adjustment     = -1
  adjustment_type        = "ChangeInCapacity"
  cooldown               = 60
  autoscaling_group_name = "${aws_autoscaling_group.web_auto_scaling.name}"
}

# CloudWatch alarm that triggers the autoscaling up policy
resource "aws_cloudwatch_metric_alarm" "web-tier_memory_high" {
  alarm_name          = "web_tier_mem_utilization_high"
  comparison_operator = "GreaterThanOrEqualToThreshold"
  evaluation_periods  = "2"
  metric_name         = "MemoryUtilization"
  namespace           = "AWS/EC2"
  period              = "60"
  statistic           = "Average"
  threshold           = "60"

  alarm_actions = [
    "${aws_autoscaling_policy.web-tier-scale-up.arn}"
  ]
  dimensions = {
    AutoScalingGroupName = "${aws_autoscaling_group.web_auto_scaling.name}"
  }
}

# CloudWatch alarm that triggers the autoscaling up policy
resource "aws_cloudwatch_metric_alarm" "web-tier_memory_low" {
  alarm_name          = "web_tier_mem_utilization_low"
  comparison_operator = "GreaterThanOrEqualToThreshold"
  evaluation_periods  = "2"
  metric_name         = "MemoryUtilization"
  namespace           = "AWS/EC2"
  period              = "60"
  statistic           = "Average"
  threshold           = "50"

  alarm_actions = [
    "${aws_autoscaling_policy.web-tier-scale-down.arn}"
  ]
  dimensions = {
    AutoScalingGroupName = "${aws_autoscaling_group.web_auto_scaling.name}"
  }
}

