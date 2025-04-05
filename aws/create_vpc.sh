#!/bin/bash

# Exit immediately if a command exits with a non-zero status
set -e

# Variables (Modify as needed)
VPC_CIDR="10.0.0.0/16"
REGION="us-east-1"
REGIONa="us-east-1a"
REGIONb="us-east-1b"
VPC_NAME="project-vpc"

# Function to check if a command was successful
check_command() {
    if [ $? -ne 0 ]; then
        echo "Error: $1"
        exit 1
    fi
}

echo "Starting VPC setup..."

### Step 1: Create VPC ###
echo "Creating VPC..."
VPC_ID=$(aws ec2 create-vpc \
    --cidr-block $VPC_CIDR \
    --instance-tenancy "default" \
    --tag-specifications "ResourceType=vpc,Tags=[{Key=Name,Value=$VPC_NAME}]" \
    --query "Vpc.VpcId" \
    --output text)
check_command "Failed to create VPC"
echo "VPC Created: $VPC_ID"

# Enable DNS Hostnames
echo "Enabling DNS Hostnames for VPC..."
aws ec2 modify-vpc-attribute --vpc-id $VPC_ID --enable-dns-hostnames Value=true
check_command "Failed to enable DNS Hostnames"

# Enable DNS Resolution
echo "Enabling DNS Resolution for VPC..."
aws ec2 modify-vpc-attribute --vpc-id $VPC_ID --enable-dns-support Value=true
check_command "Failed to enable DNS Resolution"

### Step 2: Create Subnets ###
echo "Creating Subnets..."
SUBNET_PUBLIC_1=$(aws ec2 create-subnet \
    --vpc-id $VPC_ID \
    --cidr-block "10.0.0.0/20" \
    --availability-zone "$REGIONa" \
    --tag-specifications "ResourceType=subnet,Tags=[{Key=Name,Value=project-subnet-public1-us-east-1a}]" \
    --query "Subnet.SubnetId" \
    --output text)
check_command "Failed to create Public Subnet 1"
echo "Public Subnet 1 Created: $SUBNET_PUBLIC_1"

SUBNET_PUBLIC_2=$(aws ec2 create-subnet \
    --vpc-id $VPC_ID \
    --cidr-block "10.0.16.0/20" \
    --availability-zone "$REGIONb" \
    --tag-specifications "ResourceType=subnet,Tags=[{Key=Name,Value=project-subnet-public2-us-east-1b}]" \
    --query "Subnet.SubnetId" \
    --output text)
check_command "Failed to create Public Subnet 2"
echo "Public Subnet 2 Created: $SUBNET_PUBLIC_2"

SUBNET_PRIVATE_1=$(aws ec2 create-subnet \
    --vpc-id $VPC_ID \
    --cidr-block "10.0.128.0/20" \
    --availability-zone "$REGIONa" \
    --tag-specifications "ResourceType=subnet,Tags=[{Key=Name,Value=project-subnet-private1-us-east-1a}]" \
    --query "Subnet.SubnetId" \
    --output text)
check_command "Failed to create Private Subnet 1"
echo "Private Subnet 1 Created: $SUBNET_PRIVATE_1"

SUBNET_PRIVATE_2=$(aws ec2 create-subnet \
    --vpc-id $VPC_ID \
    --cidr-block "10.0.144.0/20" \
    --availability-zone "$REGIONb" \
    --tag-specifications "ResourceType=subnet,Tags=[{Key=Name,Value=project-subnet-private2-us-east-1b}]" \
    --query "Subnet.SubnetId" \
    --output text)
check_command "Failed to create Private Subnet 2"
echo "Private Subnet 2 Created: $SUBNET_PRIVATE_2"

### Step 3: Create and Attach Internet Gateway ###
echo "Creating and attaching Internet Gateway..."
IGW_ID=$(aws ec2 create-internet-gateway \
    --tag-specifications "ResourceType=internet-gateway,Tags=[{Key=Name,Value=project-igw}]" \
    --query "InternetGateway.InternetGatewayId" \
    --output text)
check_command "Failed to create Internet Gateway"
aws ec2 attach-internet-gateway --internet-gateway-id $IGW_ID --vpc-id $VPC_ID
check_command "Failed to attach Internet Gateway"
echo "Internet Gateway Created and Attached: $IGW_ID"

### Step 4: Create Route Tables ###
echo "Creating Route Tables..."
RTB_PUBLIC=$(aws ec2 create-route-table \
    --vpc-id $VPC_ID \
    --tag-specifications "ResourceType=route-table,Tags=[{Key=Name,Value=project-rtb-public}]" \
    --query "RouteTable.RouteTableId" \
    --output text)
check_command "Failed to create Public Route Table"
echo "Public Route Table Created: $RTB_PUBLIC"

RTB_PRIVATE_1=$(aws ec2 create-route-table \
    --vpc-id $VPC_ID \
    --tag-specifications "ResourceType=route-table,Tags=[{Key=Name,Value=project-rtb-private1-us-east-1a}]" \
    --query "RouteTable.RouteTableId" \
    --output text)
check_command "Failed to create Private Route Table 1"
echo "Private Route Table 1 Created: $RTB_PRIVATE_1"

RTB_PRIVATE_2=$(aws ec2 create-route-table \
    --vpc-id $VPC_ID \
    --tag-specifications "ResourceType=route-table,Tags=[{Key=Name,Value=project-rtb-private2-us-east-1b}]" \
    --query "RouteTable.RouteTableId" \
    --output text)
check_command "Failed to create Private Route Table 2"
echo "Private Route Table 2 Created: $RTB_PRIVATE_2"

# Create a route in the public route table to allow internet access
echo "Creating route for Public Route Table..."
aws ec2 create-route --route-table-id $RTB_PUBLIC --destination-cidr-block "0.0.0.0/0" --gateway-id $IGW_ID
check_command "Failed to create route for Public Route Table"
echo "Route Created for Public Route Table"

# Associate Route Tables with Subnets
echo "Associating Route Tables with Subnets..."
aws ec2 associate-route-table --route-table-id $RTB_PUBLIC --subnet-id $SUBNET_PUBLIC_1
aws ec2 associate-route-table --route-table-id $RTB_PUBLIC --subnet-id $SUBNET_PUBLIC_2
aws ec2 associate-route-table --route-table-id $RTB_PRIVATE_1 --subnet-id $SUBNET_PRIVATE_1
aws ec2 associate-route-table --route-table-id $RTB_PRIVATE_2 --subnet-id $SUBNET_PRIVATE_2
echo "Route Tables Associated with Subnets"

### Step 5: Create VPC Endpoint for S3 ###
echo "Creating VPC Endpoint for S3..."
VPCE_ID=$(aws ec2 create-vpc-endpoint \
    --vpc-id $VPC_ID \
    --service-name "com.amazonaws.$REGION.s3" \
    --tag-specifications "ResourceType=vpc-endpoint,Tags=[{Key=Name,Value=project-vpce-s3}]" \
    --query "VpcEndpoint.VpcEndpointId" \
    --output text)
check_command "Failed to create VPC Endpoint"
aws ec2 modify-vpc-endpoint --vpc-endpoint-id $VPCE_ID --add-route-table-ids $RTB_PRIVATE_1 $RTB_PRIVATE_2
check_command "Failed to attach Route Tables to VPC Endpoint"
echo "VPC Endpoint Created: $VPCE_ID"

### Final Output ###
echo "VPC setup complete!"
echo "VPC ID: $VPC_ID"
echo "Internet Gateway ID: $IGW_ID"
echo "Public Subnets: $SUBNET_PUBLIC_1, $SUBNET_PUBLIC_2"
echo "Private Subnets: $SUBNET_PRIVATE_1, $SUBNET_PRIVATE_2"
echo "VPC Endpoint ID: $VPCE_ID"