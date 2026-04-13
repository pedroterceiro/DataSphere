data "aws_availability_zones" "available" {
  state = "available"
}

resource "aws_vpc" "main" {
  cidr_block = "192.168.0.0/16"

  tags = {
    Name = "Main"
  }
}

resource "aws_subnet" "public" {
  for_each   = var.public_subnet_cidrs
  vpc_id     = aws_vpc.main.id
  cidr_block = each.key
  availability_zone = data.aws_availability_zones.available.names[each.value]

  tags = {
    Name = "public-subnet-${each.value}"
  }
}

resource "aws_subnet" "private" {
  for_each   = var.private_subnet_cidrs
  vpc_id     = aws_vpc.main.id
  cidr_block = each.key
  availability_zone = data.aws_availability_zones.available.names[each.value]

  tags = {
    Name = "private-subnet-${each.value}"
  }
}

resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.main.id

  tags = {
    Name = "IGW"
  }
}

resource "aws_route_table" "public" {
  vpc_id = aws_vpc.main.id
  depends_on = [aws_internet_gateway.igw]

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw.id
  }

  tags = {
    Name = "Public RTB"
  }
}

resource "aws_eip" "nat" {
  for_each = var.private_subnet_cidrs

  tags = {
    Name = "NGW EIP"
  }
}

resource "aws_nat_gateway" "ngw" {
  for_each = var.private_subnet_cidrs

  allocation_id = aws_eip.nat[each.key].id
  subnet_id = aws_subnet.public[[for cidr, az in var.public_subnet_cidrs : cidr if az == each.value][0]].id

  depends_on = [aws_internet_gateway.igw]

  tags = {
    Name = "NAT-GW-${each.value}"
  }
}

resource "aws_route_table" "private" {
  for_each = var.private_subnet_cidrs

  vpc_id = aws_vpc.main.id

  route {
    cidr_block     = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.ngw[each.key].id
  }

  tags = {
    Name = "Private-RTB-${each.value}"
  }
}

resource "aws_route_table_association" "private" {
  for_each = var.private_subnet_cidrs

  subnet_id = aws_subnet.private[each.key].id
  route_table_id = aws_route_table.private[each.key].id
}

resource "aws_route_table_association" "public" {
  for_each = var.public_subnet_cidrs

  subnet_id      = aws_subnet.public[each.key].id
  route_table_id = aws_route_table.public.id
}