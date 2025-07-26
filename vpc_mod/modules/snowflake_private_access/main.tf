resource "aws_security_group" "snowflake_vpce_sg" {
  name        = "${var.environment}-snowflake-vpce-sg"
  description = "Security group for Snowflake VPC Endpoint"
  vpc_id      = var.vpc_id

  ingress {
    from_port = 443 # Snowflake uses HTTPS
    to_port   = 443
    protocol  = "tcp"
    # Allow ingress from your private subnets or specific security groups that need to access Snowflake
    cidr_blocks = var.private_subnet_cidrs # Or source_security_group_id for specific SGs
    description = "Allow HTTPS from private subnets to Snowflake VPCE"
  }

  ingress {
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = var.onprem_network_cidrs
    description = "Allow HTTPS from on-premise network to Snowflake VPCE"
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"] # Allow all outbound from VPCE (adjust if more restrictive needed)
    description = "Allow all outbound traffic from Snowflake VPCE"
  }

  tags = {
    Name        = "${var.environment}-snowflake-vpce-sg"
    Environment = var.environment
  }
}

resource "aws_vpc_endpoint" "snowflake" {
  vpc_id              = var.vpc_id
  service_name        = "com.amazonaws.vpce.us-east-1.snowflake.privatelink" # Replace us-east-1 with your region
  vpc_endpoint_type   = "Interface"
  private_dns_enabled = true # Recommended for private DNS resolution
  subnet_ids          = var.private_subnet_ids
  security_group_ids  = [aws_security_group.snowflake_vpce_sg.id]

  tags = {
    Name        = "${var.environment}-snowflake-vpce"
    Environment = var.environment
  }
}

output "snowflake_vpce_id" {
  description = "The ID of the Snowflake VPC Endpoint"
  value       = aws_vpc_endpoint.snowflake.id
}

output "snowflake_vpce_sg_id" {
  description = "The ID of the Snowflake VPC Endpoint Security Group"
  value       = aws_security_group.snowflake_vpce_sg.id
}
