# alb.tf
########################
# Web Tier Load Balancer
########################

# Generate a random string to add it to the name of the Target Group
resource "random_string" "alb_prefix" {
  length  = 4
  upper   = false
  special = false
}

resource "aws_alb" "web_lb" {
  name            = "web-load-balancer"
  subnets         = [aws_subnet.us-west-2a-public.id, aws_subnet.us-west-2b-public.id]
  security_groups = [aws_security_group.web_elb_sg.id]
  internal        = false
}

resource "aws_alb_target_group" "web" {
  name        = "web-target-group-${random_string.alb_prefix.result}"
  port        = var.web_app_port
  protocol    = "HTTP"
  vpc_id      = aws_vpc.test-vpc-for-final.id
  target_type = "instance"
  lifecycle {
    create_before_destroy = true
  }

}

# Redirect all traffic from the ALB to the target group
resource "aws_alb_listener" "web_alb_target" {
  load_balancer_arn = aws_alb.web_lb.id
  port              = var.web_app_port
  protocol          = "HTTP"

  default_action {
    target_group_arn = aws_alb_target_group.web.id
    type             = "forward"
  }
}

#################################
# Application Tier Load Balancer
#################################

resource "aws_alb" "app_lb" {
  name            = "app-load-balancer"
  subnets         = [aws_subnet.us-west-2b-private-app.id, aws_subnet.us-west-2a-private-app.id]
  security_groups = [aws_security_group.app_elb_sg.id]
  internal        = true
}

resource "aws_alb_target_group" "app" {
  name        = "app-target-group-${random_string.alb_prefix.result}"
  port        = var.app_tier_port
  protocol    = "HTTP"
  vpc_id      = aws_vpc.test-vpc-for-final.id
  target_type = "instance"
  lifecycle {
    create_before_destroy = true
  }
}

# Redirect all traffic from the ALB to the target group
resource "aws_alb_listener" "app_alb_target" {
  load_balancer_arn = aws_alb.app_lb.id
  port              = var.app_tier_port
  protocol          = "HTTP"

  default_action {
    target_group_arn = aws_alb_target_group.app.id
    type             = "forward"
  }
}
