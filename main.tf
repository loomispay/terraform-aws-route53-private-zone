resource "aws_route53_zone" "this" {
  for_each = { for k, v in var.zones : k => v if var.create }

  name          = lookup(each.value, "domain_name", each.key)
  comment       = lookup(each.value, "comment", null)
  force_destroy = lookup(each.value, "force_destroy", false)

  delegation_set_id = lookup(each.value, "delegation_set_id", null)

  dynamic "vpc" {
    for_each = try(tolist(lookup(each.value, "vpc", [])), [lookup(each.value, "vpc", {})])

    content {
      vpc_id     = vpc.value.vpc_id
      vpc_region = lookup(vpc.value, "vpc_region", null)
    }
  }

  tags = merge(
    lookup(each.value, "tags", {}),
    var.tags
  )
}

resource "aws_route53_vpc_association_authorization" "this" {
  for_each = try(tolist(lookup(each.value, "vpc", [])), [lookup(each.value, "vpc", {})])
  vpc_id  = each.value.vpc_id
  zone_id = aws_route53_zone.this.zone_id
}

#resource "aws_route53_zone_association" "example" {
#  //Add
#  provider = "aws.alternate"
#
#  vpc_id  = aws_route53_vpc_association_authorization.this.vpc_id
#  zone_id = aws_route53_vpc_association_authorization.this.zone_id
#}