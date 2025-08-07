#!/bin/bash
set -e

# Logging function with timestamps
log() {
    echo "[$(date '+%Y-%m-%d %H:%M:%S')] $1"
}

log "Starting Terraform deployment..."

# Check if terraform.tfvars exists
if [ ! -f "terraform.tfvars" ]; then
    log "ERROR: terraform.tfvars not found. Please copy from terraform.tfvars.example and configure."
    exit 1
fi

# Initialize Terraform
log "Initializing Terraform..."
if ! terraform init; then
    log "ERROR: Terraform initialization failed"
    exit 1
fi

# Validate configuration
log "Validating Terraform configuration..."
if ! terraform validate; then
    log "ERROR: Terraform validation failed"
    exit 1
fi

# Plan deployment
log "Planning Terraform deployment..."
if ! terraform plan -out=tfplan; then
    log "ERROR: Terraform planning failed"
    exit 1
fi

# Apply deployment
log "Applying Terraform deployment..."
if ! terraform apply tfplan; then
    log "ERROR: Terraform apply failed"
    exit 1
fi

log "Deployment completed successfully!"
log "ALB DNS Name: $(terraform output -raw alb_dns_name 2>/dev/null || echo 'Not available')"

if [ "$(terraform output -raw domain_name 2>/dev/null)" != "null" ] && [ "$(terraform output -raw domain_name 2>/dev/null)" != "" ]; then
    log "Domain Name: $(terraform output -raw domain_name)"
    log "Certificate ARN: $(terraform output -raw certificate_arn 2>/dev/null || echo 'Not available')"
    log "Name Servers: $(terraform output -json name_servers 2>/dev/null || echo 'Not available')"
fi

log "Deployment process completed!"