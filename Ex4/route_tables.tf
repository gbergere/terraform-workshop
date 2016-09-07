
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
