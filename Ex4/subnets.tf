
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
