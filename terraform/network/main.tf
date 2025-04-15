provider "aws" {
  region = var.region
}

data "aws_availability_zones" "available" {}

resource "aws_vpc" "main" {
  cidr_block           = var.vpc_cidr
  enable_dns_hostnames = true
  enable_dns_support   = true

  tags = {
    Name = "${var.prefix} VPC ${var.env}"
  }
}

resource "aws_internet_gateway" "main" {
  vpc_id = aws_vpc.main.id

  tags = {
    Name = "${var.prefix}-${var.env}-igw"
  }
}

resource "aws_subnet" "project_public" {
  count             = length(var.public_subnet_cidrs)
  vpc_id            = aws_vpc.main.id
  cidr_block        = var.public_subnet_cidrs[count.index]
  availability_zone = data.aws_availability_zones.available.names[count.index]

  tags = {
    Name = "${var.prefix}-${var.env}-public-subnet-${count.index + 1}"
    Tier = "Public"
  }
}

resource "aws_subnet" "project_private" {
  count             = length(var.private_subnet_cidrs)
  vpc_id            = aws_vpc.main.id
  cidr_block        = var.private_subnet_cidrs[count.index]
  availability_zone = data.aws_availability_zones.available.names[count.index]

  tags = {
    Name = "${var.prefix}-${var.env}-private-subnet-${count.index + 1}"
    Tier = "Private"
  }
}

resource "aws_eip" "nat" {
  domain = "vpc"

  tags = {
    Name = "${var.prefix}-${var.env}-nat-eip"
  }
}

resource "aws_nat_gateway" "main" {
  allocation_id = aws_eip.nat.id
  subnet_id     = aws_subnet.project_public[0].id

  tags = {
    Name = "${var.prefix}-${var.env}-nat-gw"
  }
}

# Public Route Table
resource "aws_route_table" "project_public" {
  vpc_id = aws_vpc.main.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.main.id
  }

  tags = {
    Name = "${var.prefix}-${var.env}-project_public-rt"
  }
}

# Private Route Table
resource "aws_route_table" "project_private" {
  vpc_id = aws_vpc.main.id

  route {
    cidr_block     = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.main.id
  }

  tags = {
    Name = "${var.prefix}-${var.env}-project_private-rt"
  }
}

# Route Table Associations
resource "aws_route_table_association" "project_public" {
  count          = length(aws_subnet.project_public)
  subnet_id      = aws_subnet.project_public[count.index].id
  route_table_id = aws_route_table.project_public.id
}

resource "aws_route_table_association" "project_private" {
  count          = length(aws_subnet.project_private)
  subnet_id      = aws_subnet.project_private[count.index].id
  route_table_id = aws_route_table.project_private.id
}