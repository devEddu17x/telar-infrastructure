resource "aws_subnet" "compute" {
  for_each = var.compute_subnet_cidrs

  vpc_id                  = aws_vpc.main.id
  cidr_block              = each.value
  availability_zone       = each.key
  map_public_ip_on_launch = false

  tags = var.tags
}

resource "aws_subnet" "persistence" {
  for_each = var.persistence_subnet_cidrs

  vpc_id                  = aws_vpc.main.id
  cidr_block              = each.value
  availability_zone       = each.key
  map_public_ip_on_launch = false

  tags = var.tags
}
