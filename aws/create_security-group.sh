#!/bin/bash

# Variables
SECURITY_GROUP_NAME="project-web-sg"
DESCRIPTION="Security group for web servers allowing HTTP and HTTPS"
VPC_ID="vpc-0ac52f2e12f292385"  # Replace with your VPC ID
# VPC_ID=$(aws ec2 describe-vpcs --query 'Vpcs[0].VpcId' --output text)  # Fetch default VPC ID

# Create Security Group
SECURITY_GROUP_ID=$(aws ec2 create-security-group \
    --group-name $SECURITY_GROUP_NAME \
    --description "$DESCRIPTION" \
    --vpc-id $VPC_ID \
    --query 'GroupId' --output text)

echo "Created Security Group with ID: $SECURITY_GROUP_ID"

# Allow HTTP (Port 80)
aws ec2 authorize-security-group-ingress \
    --group-id $SECURITY_GROUP_ID \
    --protocol tcp \
    --port 80 \
    --cidr 0.0.0.0/0

echo "Allowed HTTP (Port 80)"

# Allow HTTPS (Port 443)
aws ec2 authorize-security-group-ingress \
    --group-id $SECURITY_GROUP_ID \
    --protocol tcp \
    --port 443 \
    --cidr 0.0.0.0/0

echo "Allowed HTTPS (Port 443)"

# Output final security group details
echo "Security Group Created: $SECURITY_GROUP_NAME ($SECURITY_GROUP_ID) with HTTP and HTTPS access."
