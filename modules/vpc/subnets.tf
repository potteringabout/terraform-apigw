resource "aws_subnet" "subnet" {
  # local.network_subnets is a list, so we must now project it into a map
  # where each key is unique. We'll combine the network and subnet keys to
  # produce a single unique key per instance.
  for_each = tomap({
    for subnet in local.network_subnets : subnet.subnet_name => subnet
  })

  vpc_id            = aws_vpc.main.id
  availability_zone = each.value.availability_zone
  cidr_block        = each.value.cidr

  tags = {
    "Name" : each.value.subnet_name
    "zone" : each.value.zone
  }
}
