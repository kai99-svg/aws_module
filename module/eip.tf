########################################
# ELASTIC IPs AND ASSOCIATIONS
########################################

resource "aws_eip" "one" {
  network_interface = aws_network_interface.web_server.id
  depends_on        = [aws_instance.instance1]
}

resource "aws_eip" "two" {
  network_interface = aws_network_interface.web_server2.id
  depends_on        = [aws_instance.instance2]
}

resource "aws_eip_association" "prod_assoc" {
  instance_id   = aws_instance.instance1.id
  allocation_id = aws_eip.one.id
}

resource "aws_eip_association" "prod_assoc2" {
  instance_id   = aws_instance.instance2.id
  allocation_id = aws_eip.two.id
}