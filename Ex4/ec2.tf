
# AMI
data "aws_ami" "default" {

  most_recent = true

  filter {
    name = "name"
    values = ["CoreOS-stable-*-hvm"]
  }

}

data "template_file" "bootstrap" {

  template = "${file("${path.module}/entrypoint.sh")}"

}

resource "aws_launch_configuration" "lc" {

  name_prefix = "${var.name}-lc-"
  image_id = "${data.aws_ami.default.image_id}"
  instance_type = "t2.micro"
  key_name = "${aws_key_pair.myPersonalKeyPair.key_name}"
  security_groups = ["${aws_security_group.ec2.id}"]

  user_data = "${data.template_file.bootstrap.rendered}"

  lifecycle {
    create_before_destroy = true
  }

}

resource "aws_autoscaling_group" "asg" {

  vpc_zone_identifier = ["${aws_subnet.private.id}"]
  name = "${var.name}-asg"
  max_size = "2"
  min_size = "2"

  load_balancers = ["${aws_elb.public.id}"]
  health_check_grace_period = "300"
  health_check_type = "ELB"

  launch_configuration = "${aws_launch_configuration.lc.name}"

  tag {
    key = "Name"
    value = "${var.name}-ec2"
    propagate_at_launch = true
  }

  lifecycle {
    prevent_destroy = true  # Make sure you won't destroy it by mistake
  }

}

# Security Group
resource "aws_security_group" "ec2" {

  name = "${var.name}-ec2"
  description = "Workshop purpose"
  vpc_id = "${aws_vpc.default.id}"

  # Allow SSH connection inboud from Internet
  ingress {
    from_port = 22
    to_port = 22
    protocol = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  # Allow HTTP connection inboud from ELB
  ingress {
    from_port = 80
    to_port = 80
    protocol = "tcp"
    cidr_blocks = ["${aws_subnet.public.cidr_block}"]
  }

  # DNS Outbound to All
  egress {
    from_port = 53
    to_port = 53
    protocol = "udp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  # HTTP Outbound to All
  egress {
    from_port = 80
    to_port = 80
    protocol = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  # SNTP Outbound to All
  egress {
    from_port = 123
    to_port = 123
    protocol = "udp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  # HTTPS Outbound to All
  egress {
    from_port = 443
    to_port = 443
    protocol = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

}