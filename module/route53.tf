########################################
# ROUTE53 DNS RECORD
########################################

resource "aws_route53_zone" "primary" {
  name = "abc1234567.dpdns.org"
}

resource "aws_route53_record" "root" {
  zone_id = aws_route53_zone.primary.zone_id
  name    = "abc1234567.dpdns.org"
  type    = "A"

  alias {
    name                   = aws_lb.lb.dns_name
    zone_id                = aws_lb.lb.zone_id
    evaluate_target_health = true
  }
}