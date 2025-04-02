# Create an Application Load Balancer (ALB)
resource "aws_lb" "create_alb" {
  name               = "application-load-balancer-test"
  internal           = false # Set to true for internal ALB
  load_balancer_type = "application"
  security_groups    = [var.security_group_id]
  subnets            = var.private_subnets

  enable_deletion_protection = false # true: Prevent accidental deletion.
  idle_timeout               = 60   # Set idle timeout in seconds
  tags = {
    Name = "Application-Load-Balancer-Test"
    Environment = terraform.workspace
  }
}

# Create a Target Group for the ALB
resource "aws_lb_target_group" "create_tg" {
  name     = "target-group-test"
  port     = 80
  protocol = "HTTP"
  vpc_id   = var.vpc_id

  health_check {
    interval            = 30
    path                = "/"
    timeout             = 5
    healthy_threshold   = 3
    unhealthy_threshold = 3
    matcher             = "200"
  }

  tags = {
    Name = "Target-Group-Test"
    Environment = terraform.workspace
  }
}

# Create an HTTP Listener for the ALB
resource "aws_lb_listener" "http_listener_rule" {
  load_balancer_arn = aws_lb.create_alb.arn
  port              = 80
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.create_tg.arn
  }
}

# Create a Launch Template for EC2 Instances
resource "aws_launch_template" "create_launch_template" {
  name_prefix   = "test-launch-template-"
  image_id      = var.ami
  instance_type = var.instance_type
  vpc_security_group_ids = [var.security_group_id]

  # Optional: Add user data for instance initialization
  # user_data = base64encode(<<-EOF
  #   #!/bin/bash
  #   yum install -y httpd
  #   systemctl start httpd
  #   systemctl enable httpd
  # EOF
  # )

  tags = {
    Name = "Launch-Template-Test"
    Environment = terraform.workspace
  }
}

# # Create an Auto Scaling Group (ASG)
# resource "aws_autoscaling_group" "create_asg" {
#   name                = "test-asg"
#   min_size            = 1
#   max_size            = 3
#   desired_capacity    = 1
#   vpc_zone_identifier = var.private_subnets
#   health_check_type   = "ELB"
#   health_check_grace_period = 300
#   target_group_arns   = [aws_lb_target_group.create_tg.arn]

#   launch_template {
#     id      = aws_launch_template.create_launch_template.id
#     version = "$Latest"
#   }
# }
