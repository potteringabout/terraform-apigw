output "vpc_id" {
  value = aws_vpc.main.id
}

output "application_subnet_ids" {
  value = [
    for subnet_name, subnet in aws_subnet.subnet : subnet.id if strcontains(subnet_name, "app")
  ]
}

output "access_subnet_ids" {
  value = [
    for subnet_name, subnet in aws_subnet.subnet : subnet.id if strcontains(subnet_name, "access")
  ]
}
