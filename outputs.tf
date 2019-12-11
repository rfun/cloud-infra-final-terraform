# outputs.tf

output "web_alb_hostname" {
  value = aws_alb.web_lb.dns_name
}
