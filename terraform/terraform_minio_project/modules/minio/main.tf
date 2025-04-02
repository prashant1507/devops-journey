# Create MinIO Bucket
resource "aws_s3_bucket" "minio_bucket" {
  bucket = var.bucket_name
  tags = {
    Name = "minio-bucket"
  }
}

# Enable Versioning for the MinIO Bucket
resource "aws_s3_bucket_versioning" "minio_bucket_versioning" {
  bucket = aws_s3_bucket.minio_bucket.id
  versioning_configuration {
    status = "Enabled"
  }
}

# Block Public Access to the MinIO Bucket
resource "aws_s3_bucket_public_access_block" "block_public_access" {
  bucket = aws_s3_bucket.minio_bucket.id
  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}

# Create a Folder in the MinIO Bucket
resource "aws_s3_object" "create_folder" {
  bucket = aws_s3_bucket.minio_bucket.id
  key    = "${var.folder_name}/"  # Ensure the folder ends with a slash
  acl    = "private"
  depends_on = [aws_s3_bucket.minio_bucket]
}

# Upload a File to the Folder in the MinIO Bucket
resource "aws_s3_object" "upload_file" {
  bucket = aws_s3_bucket.minio_bucket.id
  key    = "${var.folder_name}/dummy-file-from-minio.txt"
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

# Data Source to List Objects in the MinIO Bucket's Folder
data "aws_s3_objects" "minio_objects_folder" {
  bucket = var.bucket_name
  prefix = "${var.folder_name}/"
  depends_on = [aws_s3_object.upload_file]
}

# Data Source to List All Objects in the MinIO Bucket
data "aws_s3_objects" "minio_objects_buckets" {
  bucket = var.bucket_name
  depends_on = [aws_s3_bucket.minio_bucket, null_resource.force_refresh]
}

# Download a Specific File from the MinIO Bucket using MinIO Client (mc)
resource "null_resource" "download_minio_file" {
  provisioner "local-exec" {
    command = <<EOT
      mc alias set local http://localhost:9000 minioadmin minioadmin
      mc cp local/${var.bucket_name}/${var.folder_name}/dummy-file-from-minio.txt ./resources/dummy-file-from-minio.txt
    EOT
  }
  depends_on = [aws_s3_object.upload_file]
}
