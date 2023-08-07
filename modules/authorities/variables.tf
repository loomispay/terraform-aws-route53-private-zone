variable "vpc_id" {
  description = "The VPC to associate with the private hosted zone"
  type        = any
  default     = {}
}

variable "zone_id" {
  description = "External private hosted zone to associate"
  type        = any
  default     = {}
}

