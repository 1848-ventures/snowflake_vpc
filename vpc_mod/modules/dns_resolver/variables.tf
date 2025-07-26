variable "environment" {
  description = "The environment name (e.g., dev, staging, prod)"
  type        = string
}

variable "vpc_id" {
  description = "The ID of the VPC where the resolver endpoint will be created"
  type        = string
}

variable "private_subnet_ids" {
  description = "A list of private subnet IDs where the resolver endpoint ENIs will be created"
  type        = list(string)
}

variable "onprem_network_cidrs" {
  description = "A list of on-premise network CIDR blocks that will query the resolver"
  type        = list(string)
  default     = [] # Set a default empty list as the value is not yet known
}
