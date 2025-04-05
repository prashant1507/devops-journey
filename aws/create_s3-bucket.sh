#!/bin/bash

# Variables
BUCKET_NAME="my-unique-bucket-name-12345"  # Replace with your desired bucket name
REGION="us-east-1"  # Change the region if needed
FOLDER_NAME="my-folder/"  # Replace with your desired folder name
FILE_PATH="/path/to/your/file.txt"  # Replace with the path to your file
DOWNLOAD_PATH="/path/to/download/location/"  # Replace with your desired download location

# Create S3 Bucket
echo "Creating S3 bucket: $BUCKET_NAME in region: $REGION"
aws s3api create-bucket --bucket $BUCKET_NAME --region $REGION --create-bucket-configuration LocationConstraint=$REGION

# Create Folder in S3 Bucket
echo "Creating folder: $FOLDER_NAME in bucket: $BUCKET_NAME"
aws s3api put-object --bucket $BUCKET_NAME --key "$FOLDER_NAME"

# Upload File to S3 Folder
echo "Uploading file: $FILE_PATH to folder: $FOLDER_NAME in bucket: $BUCKET_NAME"
aws s3 cp "$FILE_PATH" "s3://$BUCKET_NAME/$FOLDER_NAME"

# List Files in Folder
echo "Listing files in folder: $FOLDER_NAME"
aws s3 ls "s3://$BUCKET_NAME/$FOLDER_NAME"

# List All Objects in Bucket
echo "Listing all objects in bucket: $BUCKET_NAME"
aws s3 ls "s3://$BUCKET_NAME/"

# Download File from S3 Folder
echo "Downloading file from S3 bucket"
aws s3 cp "s3://$BUCKET_NAME/$FOLDER_NAME$(basename $FILE_PATH)" "$DOWNLOAD_PATH"

# Delete File from S3 Folder
echo "Deleting file from S3 bucket"
aws s3 rm "s3://$BUCKET_NAME/$FOLDER_NAME$(basename $FILE_PATH)"

echo "✅ S3 operations completed successfully!"