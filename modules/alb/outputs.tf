output "lb_address" {
  value = aws_lb.load_balancer.dns_name
}

output "target_group_arn" {
  value = aws_lb_target_group.target_group.arn
}

output "security_group_id" {
  value = aws_security_group.alb.id
}
