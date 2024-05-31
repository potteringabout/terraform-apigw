resource "aws_internet_gateway" "gw" {
  count  = var.egress || var.ingress ? 1 : 0
  vpc_id = aws_vpc.main.id

  tags = {
    Name = "main"
  }
}

resource "aws_vpc" "main" {
  # checkov:skip=CKV2_AWS_11: "Ensure VPC flow logging is enabled in all VPCs"
  # checkov:skip=CKV2_AWS_12: "Ensure the default security group of every VPC restricts all traffic"
  cidr_block = var.vpc_cidr
}
