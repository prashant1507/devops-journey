output "alb_dns_name" {
  description = "DNS name of the ALB"
  value       = aws_lb.create_alb.dns_name
}

# output "asg_name" {
#   description = "Name of the Auto Scaling Group"
#   value       = aws_autoscaling_group.create_asg.name
# }