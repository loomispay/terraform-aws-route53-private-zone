resource "aws_route53_zone_association" "this" {
  vpc_id  = var.vpc_id
  zone_id = var.zone_id
}