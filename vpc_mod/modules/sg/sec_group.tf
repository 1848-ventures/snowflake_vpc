# Security Group
resource "aws_security_group" "instance_sg" {
  name        = "tuai-${var.environment}-sg"
  description = "Allow ICMP, SSH, HTTP, and HTTPS"
  vpc_id      = var.vpc_id

  ingress {
    description = "Allow SSH"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["100.4.214.245/32"]
  }

  ingress {
    description = "Allow HTTP from VPC"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = [var.vpc_cidr]
  }

  ingress {
    description = "Allow HTTPS from VPC"
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = [var.vpc_cidr]
  }

  egress {
    description = "Allow all outbound traffic"
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    description     = "Allow HTTPS to Snowflake VPC Endpoint"
    from_port       = 443
    to_port         = 443
    protocol        = "tcp"
    security_groups = [var.snowflake_vpce_sg_id]
  }

  tags = {
    Name        = "tuai-${var.environment}-sg"
    Environment = var.environment
  }
}




