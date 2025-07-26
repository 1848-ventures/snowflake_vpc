variable "customer_gateway_bgp_asn" {
  description = "The Border Gateway Protocol (BGP) Autonomous System Number (ASN) of the customer gateway."
  type        = number
}

variable "customer_gateway_ip_address" {
  description = "The IP address of the customer gateway's outside interface."
  type        = string
}

variable "environment" {
  description = "The environment for the VPN resources."
  type        = string
}

variable "vpc_id" {
  description = "The ID of the VPC to which the VPN gateway will be attached."
  type        = string
}

variable "tunnel1_inside_cidr" {
  description = "The inside IP address CIDR block for tunnel 1."
  type        = string
}

variable "tunnel2_inside_cidr" {
  description = "The inside IP address CIDR block for tunnel 2."
  type        = string
}

variable "tunnel1_preshared_key" {
  description = "The pre-shared key for tunnel 1."
  type        = string
  sensitive   = true
}

variable "tunnel2_preshared_key" {
  description = "The pre-shared key for tunnel 2."
  type        = string
  sensitive   = true
}
