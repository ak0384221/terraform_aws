data "aws_availability_zones" "available-az" {
  state = "available"

}

locals {
  azs = slice(data.aws_availability_zones.available-az.names, 0, var.az-count)
}


#vpc
resource "aws_vpc" "custom" {
  cidr_block           = var.vpc_custom_cidr_block
  enable_dns_support   = true
  enable_dns_hostnames = true

  tags = {
    Name = "${var.name}-vpc"
  }

}

#gateway
resource "aws_internet_gateway" "gw" {
  vpc_id = aws_vpc.custom.id

  tags = {
    Name = "${var.name}-igw"
  }
}

#subnet
resource "aws_subnet" "public-a" {
  count = var.az-count

  vpc_id                  = aws_vpc.custom.id
  cidr_block              = cidrsubnet(var.vpc_custom_cidr_block, 8, count.index)
  availability_zone       = local.azs[count.index]
  map_public_ip_on_launch = true

  tags = {
    Name = "${var.name}-public-${local.azs[count.index]}"
  }
}


resource "aws_subnet" "private-a" {
  count             = var.az-count
  availability_zone = local.azs[count.index]
  vpc_id            = aws_vpc.custom.id
  cidr_block        = cidrsubnet(var.vpc_custom_cidr_block, 8, count.index + 10)

  tags = {
    Name = "${var.name}-private-${local.azs[count.index]}"
  }
}

#route table
resource "aws_route_table" "public-rt" {
  vpc_id = aws_vpc.custom.id
  tags = {
    Name = "${var.name}-rt"
  }


}

resource "aws_route_table" "private" {
  vpc_id = aws_vpc.custom.id
  tags = {
    Name = "${var.name}-private-rt"
  }

}

#aws_route
resource "aws_route" "public_internet" {
  route_table_id = aws_route_table.public-rt.id
  # destination_ = "0.0.0.0/0"
  gateway_id             = aws_internet_gateway.gw.id
  destination_cidr_block = "0.0.0.0/0"

}


#route table association
resource "aws_route_table_association" "public-custom" {
  count = var.az-count

  subnet_id      = aws_subnet.public-a[count.index].id
  route_table_id = aws_route_table.public-rt.id


}

#route table association
resource "aws_route_table_association" "private-custom" {
  count          = var.az-count
  subnet_id      = aws_subnet.private-a[count.index].id
  route_table_id = aws_route_table.private.id


}
