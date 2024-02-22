resource "aws_eip" "nat_public" {
  count = length(var.availability_zones)
}

resource "aws_nat_gateway" "nat_public" {
  count = length(var.availability_zones)

  allocation_id = aws_eip.nat_public[count.index].id
  subnet_id     = aws_subnet.public[count.index].id
}

resource "aws_route_table" "private" {
  count  = length(var.availability_zones)
  vpc_id = aws_vpc.main.id

  route {
    cidr_block     = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.nat_public[count.index].id
  }


  tags = merge(var.tags, {
    Name = format("%s-%s-%s-public-route-table-${var.availability_zones[count.index]}", var.tags["id"], var.tags["environment"], var.tags["project"])
    },
  )

}

resource "aws_route_table_association" "private" {
  count          = length(aws_subnet.private)
  subnet_id      = aws_subnet.private[count.index].id
  route_table_id = aws_route_table.private[count.index].id
}
