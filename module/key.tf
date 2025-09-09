########################################
# CREATE KEY
########################################
resource "tls_private_key" "example" {
  algorithm = "RSA"
  rsa_bits  = 2048
}

resource "aws_key_pair" "generated_key" {
  key_name   = "key"
  public_key = tls_private_key.example.public_key_openssh
}
