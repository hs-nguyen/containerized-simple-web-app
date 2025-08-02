resource "aws_key_pair" "aws-singapore-keypair" {
  key_name   = "aws-singapore-keypair"
  public_key = file("~/.ssh/id_rsa.pub") # Ensure this path points to your public key file
}