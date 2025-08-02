output "aws-singapore-keypair" {
  description = "ID of the bastion key pair"
  value       = aws_key_pair.aws-singapore-keypair.id
  
}