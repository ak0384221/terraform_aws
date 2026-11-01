data "aws_availability_zone" "available-az" {
  state = "available"

}

locals {
  azs = slice(data.aws_availability_zone.available-az.names, 0, var.az-count)
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
  vpc_id     = aws_vpc.custom.id
  cidr_block = "10.0.1.0/24"

  tags = {
    Name = "${var.name}-sub-a"
  }
}



#route table
#route table association
