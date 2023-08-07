variable "vpc_id" {
  description = "The VPC to associate with the private hosted zone"
  type        = string
}

variable "zone_id" {
  description = "External private hosted zone to associate"
  type        = string
}