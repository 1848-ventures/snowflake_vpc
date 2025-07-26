output "vpn_connection_id" {
  description = "The ID of the VPN connection."
  value       = aws_vpn_connection.main.id
}

output "vpn_gateway_id" {
  description = "The ID of the VPN gateway."
  value       = aws_vpn_gateway.main.id
}

output "customer_gateway_id" {
  description = "The ID of the customer gateway."
  value       = aws_customer_gateway.main.id
}
