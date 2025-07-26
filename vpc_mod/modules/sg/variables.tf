variable "vpc_id" {
  description = "The ID of the VPC"
  type        = string
}

variable "environment" {
  description = "Deployment environment (stg or prod)"
  type        = string
  default     = "stg"
}

variable "vpc_cidr" {
  description = "The CIDR block of the VPC."
  type        = string
}

variable "snowflake_vpce_sg_id" {
  description = "The security group ID of the Snowflake VPC endpoint."
  type        = string
}
