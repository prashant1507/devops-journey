#!/bin/bash

# Set the required parameters
INSTANCE_TYPE="t2.micro"                      # Instance type (e.g., t2.micro)
KEY_NAME="your-key-pair-name"                 # Replace with your EC2 key pair name
AMI_ID="ami-0abcdef1234567890"               # Replace with the desired AMI ID
SECURITY_GROUP_ID="sg-xxxxxxxxxxxxxxxxx"     # Replace with your security group ID
SUBNET_ID="subnet-xxxxxxxxxxxxxxxxx"          # Replace with your subnet ID
REGION="us-west-2"                            # AWS region (e.g., us-west-2)

# Launch the EC2 instance
aws ec2 run-instances \
  --image-id "$AMI_ID" \
  --instance-type "$INSTANCE_TYPE" \
  --key-name "$KEY_NAME" \
  --security-group-ids "$SECURITY_GROUP_ID" \
  --subnet-id "$SUBNET_ID" \
  --region "$REGION" \
  --count 1 \
  --output table

# Output the instance information
echo "EC2 instance is being created..."
