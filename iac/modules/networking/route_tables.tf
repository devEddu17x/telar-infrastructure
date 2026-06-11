resource "aws_route_table" "compute" {
  for_each = toset(var.availability_zones)
  vpc_id   = aws_vpc.main.id

  tags = var.tags
}

resource "aws_route_table_association" "compute" {
  for_each = aws_subnet.compute

  subnet_id      = each.value.id
  route_table_id = aws_route_table.compute[each.key].id
}

resource "aws_route_table" "persistence" {
  for_each = toset(var.availability_zones)
  vpc_id   = aws_vpc.main.id

  tags = var.tags
}

resource "aws_route_table_association" "persistence" {
  for_each = aws_subnet.persistence

  subnet_id      = each.value.id
  route_table_id = aws_route_table.persistence[each.key].id
}
