# Terraform Infrastructure Deployment

## Prerequisites
- AWS CLI configured with appropriate credentials
- Terraform installed
- Docker installed (for container builds)

## Quick Start

1. **Copy and configure variables:**
   ```bash
   cp terraform.tfvars.example terraform.tfvars
   ```

2. **Edit terraform.tfvars with your values:**
   - Set your AWS region
   - Configure VPC CIDR blocks
   - Set AMI ID for your region
   - Set key pair name
   - Set your IP for SSH access
   - Optionally configure domain name

3. **Deploy infrastructure:**
   ```bash
   ./deploy.sh
   ```

## Configuration Options

### Required Variables
- `azs`: Availability zones
- `public_subnets`: Public subnet CIDRs
- `private_subnets`: Private subnet CIDRs
- `cidr`: VPC CIDR block
- `ami`: AMI ID for EC2 instances
- `instance_type`: EC2 instance type
- `key_pair_name`: EC2 key pair name
- `allowed_ssh_cidr`: CIDR for SSH access

### Optional Variables
- `domain_name`: Domain for SSL certificate
- `create_hosted_zone`: Create new Route53 hosted zone
- `environment`: Environment name (default: dev)

## Infrastructure Components

- **VPC**: Virtual Private Cloud with public/private subnets
- **ALB**: Application Load Balancer with HTTP/HTTPS listeners
- **ECS**: Fargate cluster for containerized applications
- **ECR**: Container registry
- **Route53**: DNS management (optional)
- **ACM**: SSL certificates (optional)
- **Security Groups**: Network security
- **Bastion Host**: Secure access to private resources

## Outputs

After deployment, you'll get:
- ALB DNS name for accessing your application
- Domain name (if configured)
- SSL certificate ARN (if configured)