variable "vpc_id" {
  description = "The ID of the VPC"
  type        = string
}

variable "subnet_ids" {
  description = "The IDs of the subnets to associate the NACL with"
  type        = list(string)
}

variable "environment" {
  description = "Deployment environment (stg or prod)"
  type        = string
  default     = "stg"
}
