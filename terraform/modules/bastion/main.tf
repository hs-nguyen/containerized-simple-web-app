resource "aws_instance" "bastion_host" {
  ami           = var.ami
  instance_type = var.instance_type
  key_name = var.aws_key_pair_bastion_key_id
  subnet_id     = var.subnet_id
  security_groups = [var.security_group_id]

  tags = {
    Name = "BastionHost"
    Environment = "dev"
  }
}
