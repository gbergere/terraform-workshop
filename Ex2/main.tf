# Variables
variable "name"       { default = "geoffrey" }

# Provider
provider "aws" {

  region = "eu-west-1"

}

# VPC
resource "aws_vpc" "default" {

  cidr_block = "192.168.0.0/24"

  tags {
    Name = "${var.name}-vpc"
  }

}

# Gateways
resource "aws_internet_gateway" "default" {

  vpc_id = "${aws_vpc.default.id}"

  lifecycle {
    prevent_destroy = true  # Make sure you won't destroy it by mistake
  }

  tags {
    Name = "${var.name}-igw"
  }

}

resource "aws_eip" "nat_server_ip" {}
resource "aws_nat_gateway" "default" {

  allocation_id = "${aws_eip.nat_server_ip.id}"
  subnet_id = "${aws_subnet.public.id}"

  lifecycle {
    prevent_destroy = true  # Make sure you won't destroy it by mistake
  }

}

# Route Tables
resource "aws_route_table" "public" {

  vpc_id = "${aws_vpc.default.id}"

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = "${aws_internet_gateway.default.id}"
  }

  tags {
    Name = "${var.name}-public-rt"
  }

}

resource "aws_route_table" "private" {

  vpc_id = "${aws_vpc.default.id}"

  route {
    cidr_block = "0.0.0.0/0"
    nat_gateway_id = "${aws_nat_gateway.default.id}"
  }

  tags {
    Name = "${var.name}-private-rt"
  }

}

# Subnets
resource "aws_subnet" "public" {

  vpc_id = "${aws_vpc.default.id}"
  cidr_block = "192.168.0.0/25"

  tags {
    Name = "${var.name}-public-subnet"
  }

}

resource "aws_route_table_association" "public" {

  route_table_id = "${aws_route_table.public.id}"
  subnet_id = "${aws_subnet.public.id}"

}

resource "aws_subnet" "private" {

  vpc_id = "${aws_vpc.default.id}"
  cidr_block = "192.168.0.128/26"

  tags {
    Name = "${var.name}-private-subnet"
  }

}

resource "aws_route_table_association" "private" {

  route_table_id = "${aws_route_table.private.id}"
  subnet_id = "${aws_subnet.private.id}"

}
