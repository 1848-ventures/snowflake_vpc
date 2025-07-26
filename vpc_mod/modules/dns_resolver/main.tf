resource "aws_security_group" "resolver_sg" {
  name        = "${var.environment}-r53-resolver-sg"
  description = "Security group for Route 53 Resolver Inbound Endpoint"
  vpc_id      = var.vpc_id

  ingress {
    from_port   = 53 # DNS port
    to_port     = 53
    protocol     = "tcp"
    cidr_blocks = var.onprem_network_cidrs # Allow DNS queries from on-premise
    description = "Allow DNS (TCP) from on-premise"
  }

  ingress {
    from_port   = 53 # DNS port
    to_port     = 53
    protocol     = "udp"
    cidr_blocks = var.onprem_network_cidrs # Allow DNS queries from on-premise
    description = "Allow DNS (UDP) from on-premise"
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"] # Allow outbound to resolve DNS queries
    description = "Allow all outbound traffic for DNS resolution"
  }

  tags = {
    Name        = "${var.environment}-r53-resolver-sg"
    Environment = var.environment
  }
}

resource "aws_route53_resolver_endpoint" "inbound" {
  name               = "${var.environment}-inbound-resolver"
  direction          = "INBOUND"
  security_group_ids = [aws_security_group.resolver_sg.id]

  dynamic "ip_address" {
    for_each = var.private_subnet_ids
    content {
      subnet_id = ip_address.value
    }
  }

  tags = {
    Name        = "${var.environment}-inbound-resolver"
    Environment = var.environment
  }
}

output "resolver_endpoint_ip_addresses" {
  description = "IP addresses of the Route 53 Resolver Inbound Endpoint"
  value       = aws_route53_resolver_endpoint.inbound.ip_address[*].ip
}

resource "aws_route53_zone" "snowflake_private_link" {
  name = "privatelink.snowflakecomputing.com"
  vpc {
    vpc_id = var.vpc_id
  }
  comment = "Private Hosted Zone for Snowflake PrivateLink"
  tags = {
    Name        = "${var.environment}-snowflake-privatelink-zone"
    Environment = var.environment
  }
}

resource "aws_route53_record" "snowflake_cname_1" {
  zone_id = aws_route53_zone.snowflake_private_link.zone_id
  name    = "com.amazonaws.vpce.us-east-1.vpce-svc-01f0a00f591864bde"
  type    = "CNAME"
  ttl     = 300
  records = ["vpce-0ca310552953ce891-rmci8ckp.vpce-svc-01f0a00f591864bde.us-east-1.vpce.amazonaws.com"]
}

resource "aws_route53_record" "snowflake_cname_2" {
  zone_id = aws_route53_zone.snowflake_private_link.zone_id
  name    = "ocsp.dha32341.us-east-1.privatelink.snowflakecomputing.com"
  type    = "CNAME"
  ttl     = 300
  records = ["vpce-0ca310552953ce891-rmci8ckp.vpce-svc-01f0a00f591864bde.us-east-1.vpce.amazonaws.com"]
}