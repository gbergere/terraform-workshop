
resource "aws_security_group" "elb" {

  name = "${var.name}-elb"
  description = "Workshop purpose"
  vpc_id = "${aws_vpc.default.id}"

  # Allow HTTP connection inboud from Internet
  ingress {
    from_port = 80
    to_port = 80
    protocol = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  # Allow HTTP connection outbound to the ASG
  egress {
    from_port = 80
    to_port = 80
    protocol = "tcp"
    cidr_blocks = ["${aws_subnet.private.cidr_block}"]
  }

}

# ELB
resource "aws_elb" "public" {

  name = "${var.name}-elb"
  subnets = ["${aws_subnet.public.id}"]
  security_groups = ["${aws_security_group.elb.id}"]

  listener {
    instance_port = 80
    instance_protocol = "http"
    lb_port = 80
    lb_protocol = "http"
  }

  health_check {
    healthy_threshold = "3"
    unhealthy_threshold = "2"
    timeout = "5"
    target = "HTTP:80/"
    interval = "30"
  }

  idle_timeout = 300
  connection_draining = true
  connection_draining_timeout = 300

  tags {
    Name = "${var.name}-elb"
  }

}
