#!/bin/bash

# Variables
USER_NAME="NewUser"
GROUP_NAME="NewGroup"
POLICY_ARN="arn:aws:iam::aws:policy/AmazonS3ReadOnlyAccess"  # Example Policy
ROLE_NAME="EC2AccessRole"  # Example Role 

# Create IAM User
echo "Creating IAM User: $USER_NAME..."
aws iam create-user --user-name $USER_NAME
if [ $? -eq 0 ]; then
    echo "User $USER_NAME created successfully."
else
    echo "Failed to create user $USER_NAME."
    exit 1
fi

# Create IAM Group
echo "Creating IAM Group: $GROUP_NAME..."
aws iam create-group --group-name $GROUP_NAME
if [ $? -eq 0 ]; then
    echo "Group $GROUP_NAME created successfully."
else
    echo "Failed to create group $GROUP_NAME."
    exit 1
fi

# Attach Policy to the Group
echo "Attaching policy $POLICY_ARN to group $GROUP_NAME..."
aws iam attach-group-policy --group-name $GROUP_NAME --policy-arn $POLICY_ARN
if [ $? -eq 0 ]; then
    echo "Policy attached to group $GROUP_NAME successfully."
else
    echo "Failed to attach policy to group $GROUP_NAME."
    exit 1
fi

# Add User to the Group
echo "Adding user $USER_NAME to group $GROUP_NAME..."
aws iam add-user-to-group --user-name $USER_NAME --group-name $GROUP_NAME
if [ $? -eq 0 ]; then
    echo "User $USER_NAME added to group $GROUP_NAME successfully."
else
    echo "Failed to add user to group."
    exit 1
fi

# Attach Role to the User (Assume the role exists)
echo "Attaching role $ROLE_NAME to user $USER_NAME..."
aws iam attach-user-policy --user-name $USER_NAME --policy-arn arn:aws:iam::aws:policy/AmazonEC2ReadOnlyAccess  # Example role 
if [ $? -eq 0 ]; then
    echo "Role $ROLE_NAME attached to user $USER_NAME successfully."
else
    echo "Failed to attach role to user."
    exit 1
fi

echo "IAM User, Group, Policy, and Role setup complete."
