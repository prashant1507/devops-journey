# Generate a Random Suffix for Bucket Name
resource "random_string" "suffix" {
  length  = 6
  special = false
  upper   = false
}

# Local Variables
locals {
  bucket_name = "${var.bucket_name}-${random_string.suffix.result}"
}

# Create S3 Bucket
resource "aws_s3_bucket" "s3_bucket" {
  bucket = local.bucket_name
  tags = {
    Name = "s3-bucket"
  }
}

# Enable Versioning for the S3 Bucket
resource "aws_s3_bucket_versioning" "s3_bucket_versioning" {
  bucket = aws_s3_bucket.s3_bucket.id
  versioning_configuration {
    status = "Enabled"
  }
}

# Block Public Access to the S3 Bucket
resource "aws_s3_bucket_public_access_block" "block_public_access" {
  bucket = aws_s3_bucket.s3_bucket.id
  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}

# Create a Folder in the S3 Bucket
resource "aws_s3_object" "create_folder" {
  bucket = aws_s3_bucket.s3_bucket.id
  key    = "${var.folder_name}/"  # Ensure the folder ends with a slash
  acl    = "private"
  depends_on = [aws_s3_bucket.s3_bucket]
}

# Upload a File to the Folder in the S3 Bucket
resource "aws_s3_object" "upload_file" {
  bucket = aws_s3_bucket.s3_bucket.id
  key    = "${var.folder_name}/dummy-file-from-s3.txt"
  source = "./resources/dummy-file.txt"
  etag   = filemd5("./resources/dummy-file.txt")  # Ensures the file is uploaded only if it changes
  acl    = "private"
  depends_on = [aws_s3_object.create_folder]
}

# Force Terraform to Refresh the Data Source After File Upload
resource "null_resource" "force_refresh" {
  triggers = {
    upload_timestamp = timestamp()  # Forces recreation when `apply` runs
  }
  depends_on = [aws_s3_object.upload_file]
}

# Data Source to List Objects in the S3 Bucket's Folder
data "aws_s3_objects" "s3_objects_folder" {
  bucket = local.bucket_name
  prefix = "${var.folder_name}/"
  depends_on = [aws_s3_object.upload_file]
}

# Data Source to List All Objects in the S3 Bucket
data "aws_s3_objects" "s3_objects_buckets" {
  bucket = local.bucket_name
  depends_on = [aws_s3_bucket.s3_bucket, null_resource.force_refresh]
}

# Download a Specific File from the S3 Bucket
resource "null_resource" "download_s3_file" {
  provisioner "local-exec" {
    command = "aws s3 cp s3://${local.bucket_name}/${var.folder_name}/dummy-file-from-s3.txt ./resources/dummy-file-from-s3.txt"
  }
  depends_on = [aws_s3_object.upload_file]
}