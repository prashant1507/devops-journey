#!/bin/bash

# Exit immediately if a command exits with a non-zero status
set -e

# Variables (Update these based on your AWS setup)
LOAD_BALANCER_NAME="project-load-balancer"  # Replace with your desired Load Balancer name
VPC_ID="vpc-xxxxxxxx"             # Replace with your VPC ID
SUBNETS="subnet-xxxxx subnet-yyyyy"  # Replace with your Subnet IDs
SECURITY_GROUP_ID="sg-xxxxxxxx"    # Replace with your Security Group ID
SCHEME="internet-facing"           # Options: internet-facing or internal
IP_TYPE="ipv4"
LB_TYPE="application"
TARGET_GROUP_NAME="MyTargetGroup"
PORT=80
PROTOCOL="HTTP"
INSTANCE_IDS="i-xxxxxxxx i-yyyyyyyy"  # Replace with your EC2 Instance IDs

# Function to check if a command was successful
check_command() {
    if [ $? -ne 0 ]; then
        echo "Error: $1"
        exit 1
    fi
}

### Step 1: Create Target Group ###
echo "Creating Target Group..."
TARGET_GROUP_ARN=$(aws elbv2 create-target-group \
    --name $TARGET_GROUP_NAME \
    --protocol $PROTOCOL \
    --port $PORT \
    --vpc-id $VPC_ID \
    --target-type instance \
    --query 'TargetGroups[0].TargetGroupArn' \
    --output text)
check_command "Failed to create Target Group"
echo "Target Group Created: $TARGET_GROUP_ARN"

### Step 2: Register Instances with Target Group ###
echo "Registering Instances with Target Group..."
aws elbv2 register-targets \
    --target-group-arn $TARGET_GROUP_ARN \
    --targets $(echo $INSTANCE_IDS | sed 's/\([^ ]\+\)/Id=\1/g')
check_command "Failed to register instances with Target Group"
echo "Instances Registered to Target Group!"

### Step 3: Create Application Load Balancer ###
echo "Creating Application Load Balancer..."
LOAD_BALANCER_ARN=$(aws elbv2 create-load-balancer \
    --name $LOAD_BALANCER_NAME \
    --subnets $SUBNETS \
    --security-groups $SECURITY_GROUP_ID \
    --scheme $SCHEME \
    --type $LB_TYPE \
    --ip-address-type $IP_TYPE \
    --query 'LoadBalancers[0].LoadBalancerArn' \
    --output text)
check_command "Failed to create Load Balancer"
echo "Load Balancer Created: $LOAD_BALANCER_ARN"

### Step 4: Create Listener for ALB ###
echo "Creating Listener for Load Balancer..."
LISTENER_ARN=$(aws elbv2 create-listener \
    --load-balancer-arn $LOAD_BALANCER_ARN \
    --protocol $PROTOCOL \
    --port $PORT \
    --default-actions Type=forward,TargetGroupArn=$TARGET_GROUP_ARN \
    --query 'Listeners[0].ListenerArn' \
    --output text)
check_command "Failed to create Listener"
echo "Listener Created: $LISTENER_ARN"

echo "Application Load Balancer with Listener and Target Group is set up successfully!"