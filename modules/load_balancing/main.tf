# create alb tg for port 3000 ec2 instances
resource "aws_lb_target_group" "ec2-lb" {
  count = length(var.subnets)
  name             = "smart-home-tg-${count.index}"
  port             = 3000
  protocol         = "HTTP"
  protocol_version = "HTTP1"
  vpc_id           = var.vpc_id

  health_check {
    path     = "/health-check"
    protocol = "HTTP"
  }
}

# attach the ec2 instance to the group for load balancer
resource "aws_lb_target_group_attachment" "ec2-lb-group" {
  count            = length(var.ec2_id)
  target_group_arn = aws_lb_target_group.ec2-lb[count.index].arn
  target_id        = var.ec2_id[count.index]
  port             = 3000
}

# configure a load balancer for all instances where the app is running
resource "aws_lb" "smart_home_alb" {
  name               = "smart-home-lb"
  internal           = false
  load_balancer_type = "application"
  security_groups    = var.security_groups
  subnets            = var.subnets

  enable_deletion_protection = false

  tags = {
    Environment = "production"
  }
}

# configure the alb listner
resource "aws_lb_listener" "smart_home_listner" {
  # count = length(var.subnets)
  load_balancer_arn = aws_lb.smart_home_alb.arn
  port              = "80"
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.ec2-lb[0].arn
   
  }
}

resource "aws_lb_listener_rule" "status" {
  # count = length(var.subnets)
  listener_arn = aws_lb_listener.smart_home_listner.arn
#   priority     = 100

  action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.ec2-lb[0].arn
  }

  condition {
    path_pattern {
      values = ["status/*"]
    }
  }
}

resource "aws_lb_listener_rule" "heating" {
  # count = length(var.subnets)
  listener_arn = aws_lb_listener.smart_home_listner.arn
#   priority     = 100

  action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.ec2-lb[1].arn
  }

  condition {
    path_pattern {
      values = ["heating/*"]
    }
  }
}

resource "aws_lb_listener_rule" "lights" {
  # count = length(var.subnets)
  listener_arn = aws_lb_listener.smart_home_listner.arn
#   priority     = 100

  action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.ec2-lb[2].arn
  }

  condition {
    path_pattern {
      values = ["lights/*"]
    }
  }
}