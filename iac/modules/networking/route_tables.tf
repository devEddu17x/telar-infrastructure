resource "aws_route_table" "public" {
  vpc_id = aws_vpc.main.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.main.id
  }

  tags = merge(var.tags, {
    Name = "${var.name_prefix}-public-rt"
  })
}

resource "aws_route_table_association" "public" {
  for_each = aws_subnet.public

  subnet_id      = each.value.id
  route_table_id = aws_route_table.public.id
}

resource "aws_route_table" "private_compute" {
  for_each = { for az in var.availability_zones : az => az }

  vpc_id = aws_vpc.main.id

  tags = merge(var.tags, {
    Name = "${var.name_prefix}-private-compute-rt-${each.key}"
  })
}

resource "aws_route_table_association" "private_compute" {
  for_each = aws_subnet.private_compute

  subnet_id      = each.value.id
  route_table_id = aws_route_table.private_compute[each.key].id
}

resource "aws_route_table" "private_persistence" {
  vpc_id = aws_vpc.main.id

  tags = merge(var.tags, {
    Name = "${var.name_prefix}-private-persistence-rt"
  })
}

resource "aws_route_table_association" "private_persistence" {
  for_each = aws_subnet.private_persistence

  subnet_id      = each.value.id
  route_table_id = aws_route_table.private_persistence.id
}
