
resource "aws_key_pair" "myPersonalKeyPair" {

  key_name = "${var.name}-keypair"
  public_key = "${file("~/.ssh/id_rsa.pub")}"

}
