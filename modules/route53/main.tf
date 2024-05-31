data "aws_route53_zone" "zone" {
  name         = var.zone
  private_zone = false
}

resource "aws_route53_record" "www-live" {
  zone_id = data.aws_route53_zone.zone.zone_id
  name    = var.name
  type    = "CNAME"
  ttl     = 5

  records = [var.address]
}
