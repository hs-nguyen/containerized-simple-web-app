resource "aws_instance" "bastion_host" {
  ami           = var.ami
  instance_type = var.instance_type
  key_name = var.aws_key_pair_bastion_key_id
  subnet_id     = var.subnet_id
  vpc_security_group_ids = [var.security_group_id]
  monitoring = true

  root_block_device {
    encrypted = true
    volume_type = "gp3"
    volume_size = 20
  }

  tags = {
    Name = "BastionHost"
    Environment = var.environment
  }
}
