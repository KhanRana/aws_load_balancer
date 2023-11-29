# output alb id
output "lb-tg-id" {
  value = aws_lb_target_group.ec2-lb[*].id
}

# output ec2 target group arn
output "lb-tg-arn" {
  value = aws_lb_target_group.ec2-lb[*].arn
}

# output load balancer arn
output "alb_forward_arn" {
  value = aws_lb.smart_home_alb.arn
}