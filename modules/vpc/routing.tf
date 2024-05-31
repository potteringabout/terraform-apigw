resource "aws_route_table" "access" {
  count  = var.egress || var.ingress ? 1 : 0
  vpc_id = aws_vpc.main.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.gw[0].id
  }
}

resource "aws_route_table_association" "access" {
  for_each       = tomap(var.egress || var.ingress ? local.access_subnets : {})
  subnet_id      = aws_subnet.subnet[each.value.subnet_name].id
  route_table_id = aws_route_table.access[0].id
}

# If egress is set, we will have a NAT gw per access subnet.
# If that's the case we need to create separate route tables for each
# application subnet pointing at the nat gw in the same zone.
# If egress is not set we just create a single route table for all app subnets
resource "aws_route_table" "app" {
  for_each = tomap(var.egress ? local.access_subnets : { "app" : {} })

  vpc_id = aws_vpc.main.id

  dynamic "route" {
    # We only add the block if egress is true, and we point the internet route
    # at the nat gw
    for_each = var.egress ? [each.value.subnet_name] : []
    content {
      cidr_block     = "0.0.0.0/0"
      nat_gateway_id = aws_nat_gateway.nat[each.value.subnet_name].id
    }
  }
}

/*resource "aws_route" "nat" {
  for_each = tomap(var.egress ? local.access_subnets : {})

  route_table_id         = aws_route_table.app[each.value.subnet_name].id
  destination_cidr_block = "0.0.0.0/0"
  nat_gateway_id         = aws_nat_gateway.nat[each.value.subnet_name].id
}*/

locals {
  app_subnets = {
    for subnet in local.network_subnets : subnet.subnet_name => subnet if subnet.zone == "app"
  }

  app_route_table_association_egress = {
    for subnet in local.app_subnets : subnet.subnet_name => "access${subnet.subnet_number}"
  }
  app_route_table_association_noegress = {
    for subnet in local.app_subnets : subnet.subnet_name => "app"
  }
}

resource "aws_route_table_association" "app" {
  for_each       = tomap(var.egress ? local.app_route_table_association_egress : local.app_route_table_association_noegress)
  subnet_id      = aws_subnet.subnet[each.key].id
  route_table_id = aws_route_table.app[each.value].id
}
