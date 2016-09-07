# Variables
variable "name"       { default = "geoffrey" }
variable "vpc_id"     { default = "vpc-xxx" }
variable "subnet_id"  { default = "subnet-xxx" }

# Provider
provider "aws" {

  region = "eu-west-1"

}

# AMI
data "aws_ami" "default" {

  most_recent = true

  filter {
    name = "name"
    values = ["CoreOS-stable-*-hvm"]
  }

}

# SSH Key Pair
resource "aws_key_pair" "myPersonalKeyPair" {

  key_name = "${var.name}-keypair"
  public_key = "${file("~/.ssh/id_rsa.pub")}"

}

# Security Group
resource "aws_security_group" "myFirstSecurityGroup" {

  name = "${var.name}-sg"
  description = "Workshop purpose"
  vpc_id = "${var.vpc_id}"

  ingress {
    from_port = 22
    to_port = 22
    protocol = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

}

# EC2 Instance
resource "aws_instance" "myFirstInstance" {

  instance_type = "t2.micro"
  ami = "${data.aws_ami.default.image_id}"
  key_name = "${aws_key_pair.myPersonalKeyPair.key_name}"
  security_groups = ["${aws_security_group.myFirstSecurityGroup.id}"]
  subnet_id = "${var.subnet_id}"
  associate_public_ip_address = true

  tags {
    Name = "${var.name}-instance"
  }

  lifecycle {
    prevent_destroy = true  # Make sure you won't destroy it by mistake
  }

}

# Output Values
output "instance_public_ip" {
  value = "${aws_instance.myFirstInstance.public_ip}"
}