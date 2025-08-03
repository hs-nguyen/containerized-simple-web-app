#!/bin/bash
set -e

# Variables - can be overridden by environment variables
AWS_REGION="${AWS_REGION:-ap-southeast-1}"
ECR_REPO="${ECR_REPO:-simple-web-app}"
IMAGE_TAG="${IMAGE_TAG:-latest}"

echo "Deploying to region: $AWS_REGION"
echo "ECR Repository: $ECR_REPO"
echo "Image Tag: $IMAGE_TAG"

# Get ECR repository URI
ECR_URI=$(aws ecr describe-repositories --repository-names "$ECR_REPO" --region "$AWS_REGION" --query 'repositories[0].repositoryUri' --output text)

if [ -z "$ECR_URI" ]; then
    echo "Error: Could not retrieve ECR repository URI"
    exit 1
fi

echo "ECR URI: $ECR_URI"

# Login to ECR
echo "Logging into ECR..."
aws ecr get-login-password --region "$AWS_REGION" | docker login --username AWS --password-stdin "$ECR_URI"

# Build image
echo "Building Docker image..."
docker build -t "$ECR_REPO:$IMAGE_TAG" .

# Tag image for ECR
echo "Tagging image for ECR..."
docker tag "$ECR_REPO:$IMAGE_TAG" "$ECR_URI:$IMAGE_TAG"

# Push to ECR
echo "Pushing image to ECR..."
docker push "$ECR_URI:$IMAGE_TAG"

echo "Successfully pushed image to: $ECR_URI:$IMAGE_TAG"