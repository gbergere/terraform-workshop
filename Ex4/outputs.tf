
output "elb" {
  value = "${aws_elb.public.dns_name}"
}