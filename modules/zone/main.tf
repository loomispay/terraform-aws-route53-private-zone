locals {
  zone_vpcs = flatten([
    for zone_key, zone in aws_route53_zone.this : {
      for vpc in zone.vpc : "${zone_key}-${vpc.vpc_id}" => {
        zone_id = zone.zone_id,
        vpc_id  = vpc.vpc_id
      }
    }
  ])[0]
}

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
  for_each = local.zone_vpcs

  zone_id    = each.value.zone_id
  vpc_id     = each.value.vpc_id
}