
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
