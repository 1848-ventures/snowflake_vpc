data "aws_region" "current" {}

resource "aws_vpc_endpoint" "s3" {
  vpc_id            = var.vpc_id
  service_name      = "com.amazonaws.${data.aws_region.current.id}.s3"
  vpc_endpoint_type = "Gateway"
  route_table_ids   = var.route_table_ids
  tags              = merge(
    {
      "Name" = "s3-gateway-endpoint"
    },
    var.tags,
  )
}
