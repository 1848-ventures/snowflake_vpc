variable "region" {
  description = "The AWS region to deploy to."
  type        = string
}

variable "ssh_private_key_path" {
  description = "Path to the SSH private key"
  type        = string
}
variable "ssh_public_key_path" {
  description = "Path to the SSH public key"
  type        = string
}

variable "vpc_cidr" {
  description = "CIDR block for the VPC"
  type        = string
  default     = "10.0.0.0/16"
}

variable "environment" {
  description = "Deployment environment (stg or prod)"
  type        = string
  default     = "stg"
}

variable "onprem_network_cidrs" {
  description = "List of on-premise network CIDR blocks for VPN and DNS access"
  type        = list(string)
  default     = []
}