#!/bin/bash

# Variables
AWS_REGION="us-east-1"
ECR_REPO="simple-web-app"
IMAGE_TAG="latest"

# Get ECR repository URI
ECR_URI=$(aws ecr describe-repositories --repository-names $ECR_REPO --region $AWS_REGION --query 'repositories[0].repositoryUri' --output text)

# Login to ECR
aws ecr get-login-password --region $AWS_REGION | docker login --username AWS --password-stdin $ECR_URI

# Build image
docker build -t $ECR_REPO:$IMAGE_TAG .

# Tag image for ECR
docker tag $ECR_REPO:$IMAGE_TAG $ECR_URI:$IMAGE_TAG

# Push to ECR
docker push $ECR_URI:$IMAGE_TAG

echo "Image pushed to: $ECR_URI:$IMAGE_TAG"