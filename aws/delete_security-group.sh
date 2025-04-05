#!/bin/bash

# Variables - change these as needed
SECURITY_GROUP_ID="sg-0e4e15a85e316b5dd"  # Replace with your security group ID
REGION="us-east-1"                        # Replace with your desired AWS region

# Check if AWS CLI is installed
if ! command -v aws &> /dev/null
then
    echo "AWS CLI is not installed. Exiting."
    exit 1
fi

# Delete the security group
echo "Deleting security group: $SECURITY_GROUP_ID in region $REGION..."
aws ec2 delete-security-group --group-id "$SECURITY_GROUP_ID" --region "$REGION"

# Check if deletion was successful
if [ $? -eq 0 ]; then
    echo "Security group $SECURITY_GROUP_ID deleted successfully."
else
    echo "Failed to delete security group $SECURITY_GROUP_ID."
fi
