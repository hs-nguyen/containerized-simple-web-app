#!/bin/bash
set -e

echo "Starting Terraform deployment..."

# Initialize Terraform
echo "Initializing Terraform..."
terraform init

# Validate configuration
echo "Validating Terraform configuration..."
terraform validate

# Plan deployment
echo "Planning Terraform deployment..."
terraform plan --var-file terraform.tfvars

# Apply deployment
echo "Applying Terraform deployment..."
terraform apply --var-file terraform.tfvars -auto-approve

echo "Deployment completed successfully!"
echo "ALB DNS Name: $(terraform output -raw alb_dns_name)"

if [ "$(terraform output -raw domain_name)" != "null" ]; then
    echo "Domain Name: $(terraform output -raw domain_name)"
    echo "Certificate ARN: $(terraform output -raw certificate_arn)"
fi