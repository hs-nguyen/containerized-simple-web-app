resource "aws_instance" "ansible" {
  ami           = var.ami
  instance_type = var.instance_type
  key_name = var.aws_key_pair_bastion_key_id
  subnet_id     = var.subnet_id
  security_groups = [var.security_group_id]

  tags = {
    Name = "ansible-host"
    Environment = "dev"
    description = "Ansible host for managing other instances"
  }
}
resource "aws_instance" "monitoring-sv" {
  ami           = var.ami
  instance_type = var.instance_type
  key_name = var.aws_key_pair_bastion_key_id
  subnet_id     = var.subnet_id
  security_groups = [var.security_group_id]

  tags = {
    Name = "prometheus-grafana"
    Environment = "dev"
    description = "Install prometheus and grafana"
  }
}