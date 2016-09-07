
resource "aws_vpc" "default" {

  cidr_block = "192.168.0.0/24"

  tags {
    Name = "${var.name}-vpc"
  }

}
