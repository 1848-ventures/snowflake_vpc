output "vpc_id" {
  description = "The ID of the VPC"
  value       = aws_vpc.main.id

}

output "public_subnet_ids" {
  description = "Public subnet IDs"
  value       = [for s in aws_subnet.public : s.id]
}

output "private_subnet_ids" {
  description = "Private subnet IDs"
  value       = [for s in aws_subnet.private : s.id]
}
output "vpc_cidr" {
  description = "CIDR block for the VPC"
  value       = var.vpc_cidr
}

output "public_subnet_cidr" {
  description = "CIDR for public subnet"
  value       = var.public_sub_cidr
}
output "private_subnet_cidr" {
  description = "CIDRs for private subnet"
  value       = var.priv_sub_cidr
}

output "public_subnet_azs" {
  description = "Availability zones for public subnets"
  value       = var.public_subnet_az
}

output "private_subnet_azs" {
  description = "Availability zones for private subnets"
  value       = var.private_subnet_az
}


output "environment" {
  description = "Environment for the VPC"
  value       = var.environment

}

output "private_subnet_cidrs" {
  description = "List of private subnet CIDR blocks"
  value       = [for s in aws_subnet.private : s.cidr_block]
}

output "public_route_table_id" {
  description = "The ID of the public route table"
  value       = aws_route_table.public_rt.id
}

output "private_route_table_ids" {
  description = "The IDs of the private route tables"
  value       = [for table in aws_route_table.private_rt : table.id]
}