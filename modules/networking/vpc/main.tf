data "aws_availability_zones" "available" {
  state = "available"
}

resource "aws_vpc" "this" {
  cidr_block = "192.168.0.0/16"

  tags = {
    Name = "${var.project_name}-vpc"
  }
}

resource "aws_subnet" "public" {
  for_each          = var.public_subnet_cidrs
  vpc_id            = aws_vpc.this.id
  cidr_block        = each.key
  availability_zone = data.aws_availability_zones.available.names[each.value]

  tags = {
    Name = "${var.project_name}-public-subnet-${each.value}"
  }
}

resource "aws_subnet" "private" {
  for_each          = var.private_subnet_cidrs
  vpc_id            = aws_vpc.this.id
  cidr_block        = each.key
  availability_zone = data.aws_availability_zones.available.names[each.value]

  tags = {
    Name = "${var.project_name}-private-subnet-${each.value}"
  }
}

resource "aws_internet_gateway" "this" {
  vpc_id = aws_vpc.this.id

  tags = {
    Name = "${var.project_name}-igw"
  }
}

resource "aws_route_table" "public" {
  vpc_id = aws_vpc.this.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.this.id
  }

  tags = {
    Name = "${var.project_name}-public-rtb"
  }
}

resource "aws_eip" "nat" {
  for_each = var.private_subnet_cidrs

  tags = {
    Name = "${var.project_name}-nat-eip-${each.value}"
  }
}

resource "aws_nat_gateway" "this" {
  for_each = var.private_subnet_cidrs

  allocation_id = aws_eip.nat[each.key].id
  subnet_id     = aws_subnet.public[[for cidr, az in var.public_subnet_cidrs : cidr if az == each.value][0]].id

  tags = {
    Name = "${var.project_name}-nat-gw-${each.value}"
  }
}

resource "aws_route_table" "private" {
  for_each = var.private_subnet_cidrs

  vpc_id = aws_vpc.this.id

  route {
    cidr_block     = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.this[each.key].id
  }

  tags = {
    Name = "${var.project_name}-private-rtb-${each.value}"
  }
}

resource "aws_route_table_association" "private" {
  for_each = var.private_subnet_cidrs

  subnet_id      = aws_subnet.private[each.key].id
  route_table_id = aws_route_table.private[each.key].id
}

resource "aws_route_table_association" "public" {
  for_each = var.public_subnet_cidrs

  subnet_id      = aws_subnet.public[each.key].id
  route_table_id = aws_route_table.public.id
}
