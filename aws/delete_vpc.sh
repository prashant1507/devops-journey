#!/bin/bash

# Exit on any error
set -e

# Variables (must match those used in creation script)
REGION="us-east-1"
REGIONa="us-east-1a"
REGIONb="us-east-1b"

# Get VPC ID by name tag
VPC_ID="vpc-0f5d613ec0dde6402" # Replace with your VPC ID

if [ "$VPC_ID" == "None" ]; then
    echo "No VPC found with Name=project-vpc"
    exit 1
fi
echo "Found VPC ID: $VPC_ID"

### Step 1: Delete VPC Endpoint ###
echo "Deleting VPC Endpoint..."
VPCE_ID=$(aws ec2 describe-vpc-endpoints \
    --filters "Name=vpc-id,Values=$VPC_ID" "Name=tag:Name,Values=project-vpce-s3" \
    --query "VpcEndpoints[0].VpcEndpointId" \
    --region $REGION \
    --output text)
if [ "$VPCE_ID" != "None" ]; then
    aws ec2 delete-vpc-endpoints --vpc-endpoint-ids $VPCE_ID --region $REGION
    echo "Deleted VPC Endpoint: $VPCE_ID"
fi

### Step 2: Disassociate and Delete Route Tables ###
echo "Deleting Route Tables..."
RTB_IDS=$(aws ec2 describe-route-tables \
    --filters "Name=vpc-id,Values=$VPC_ID" \
    --query "RouteTables[?Tags[?Value=='project-rtb-public' || Value=='project-rtb-private1-us-east-1a' || Value=='project-rtb-private2-us-east-1b']].RouteTableId" \
    --region $REGION \
    --output text)

for rtb_id in $RTB_IDS; do
    ASSOCIATION_IDS=$(aws ec2 describe-route-tables \
        --route-table-ids $rtb_id \
        --query "RouteTables[0].Associations[?Main==\`false\`].RouteTableAssociationId" \
        --region $REGION \
        --output text)
    for assoc_id in $ASSOCIATION_IDS; do
        aws ec2 disassociate-route-table --association-id $assoc_id --region $REGION
        echo "Disassociated $assoc_id from $rtb_id"
    done

    aws ec2 delete-route-table --route-table-id $rtb_id --region $REGION
    echo "Deleted Route Table: $rtb_id"
done

### Step 3: Detach and Delete Internet Gateway ###
echo "Deleting Internet Gateway..."
IGW_ID=$(aws ec2 describe-internet-gateways \
    --filters "Name=attachment.vpc-id,Values=$VPC_ID" \
    --query "InternetGateways[0].InternetGatewayId" \
    --region $REGION \
    --output text)
if [ "$IGW_ID" != "None" ]; then
    aws ec2 detach-internet-gateway --internet-gateway-id $IGW_ID --vpc-id $VPC_ID --region $REGION
    aws ec2 delete-internet-gateway --internet-gateway-id $IGW_ID --region $REGION
    echo "Deleted Internet Gateway: $IGW_ID"
fi

### Step 4: Delete Subnets ###
echo "Deleting Subnets..."
SUBNET_IDS=$(aws ec2 describe-subnets \
    --filters "Name=vpc-id,Values=$VPC_ID" \
    --query "Subnets[].SubnetId" \
    --region $REGION \
    --output text)
for subnet_id in $SUBNET_IDS; do
    aws ec2 delete-subnet --subnet-id $subnet_id --region $REGION
    echo "Deleted Subnet: $subnet_id"
done

### Step 5: Delete the VPC ###
echo "Deleting VPC: $VPC_ID"
aws ec2 delete-vpc --vpc-id $VPC_ID --region $REGION
echo "VPC Deleted!"

echo "✅ VPC teardown complete!"
