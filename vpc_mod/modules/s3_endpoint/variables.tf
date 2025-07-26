variable "vpc_id" {
  description = "The ID of the VPC where the endpoint will be created."
  type        = string
}

variable "route_table_ids" {
  description = "A list of route table IDs to associate with the endpoint."
  type        = list(string)
}

variable "tags" {
  description = "A map of tags to assign to the endpoint."
  type        = map(string)
  default     = {}
}
