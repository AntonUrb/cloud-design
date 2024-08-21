resource "aws_route_table" "private" {
  vpc_id = aws_vpc.main.id

  route = {
    cidr_block = var.all_traffic_cidr
  }
}