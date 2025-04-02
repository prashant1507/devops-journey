# Create IAM User Group
resource "aws_iam_group" "user_group" {
  name = "test-user-group"
  path = "/testing/"  # Specifies a hierarchical path for organizing IAM groups.
}

# Attach Predefined Policy to IAM User Group
resource "aws_iam_group_policy_attachment" "attach_predefined_policy" {
  group      = aws_iam_group.user_group.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonS3FullAccess"
}

# Create IAM User
resource "aws_iam_user" "test_user" {
  name = var.user_name
  tags = {
    Name = var.user_name
  }
}

# Attach a Login Profile (AWS Management Console Access)
resource "aws_iam_user_login_profile" "user_profile" {
  user                    = aws_iam_user.test_user.name
  password_reset_required = false  # User does NOT need to reset password at next login
}

# Add IAM User to Group
resource "aws_iam_group_membership" "add_test_user_to_group" {
  name  = "group_membership"
  group = aws_iam_group.user_group.name
  users = [
    aws_iam_user.test_user.name
  ]
}

# Grant Full Access to S3 for IAM User
resource "aws_s3_bucket_policy" "s3_bucket_policy" {
  bucket = var.s3_bucket_id

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Sid       = "AllowSpecificIAMUserAccess"
        Effect    = "Allow"
        Principal = {
          AWS = aws_iam_user.test_user.arn
        }
        Action    = "s3:*"
        Resource  = [
          var.s3_bucket_arn,
          "${var.s3_bucket_arn}/*"
        ]
      }
    ]
  })
}

# Upload a File to the Folder in the S3 Bucket
resource "aws_s3_object" "upload_file" {
  bucket = var.s3_bucket_id
  key    = "${var.folder_name}/dummy-file-upload-by-iam-user.txt"
  source = "./resources/dummy-file.txt"
  etag   = filemd5("./resources/dummy-file.txt")  # Ensures the file is uploaded only if it changes
}

# Verify if the File is Uploaded in the S3 Folder
data "aws_s3_objects" "s3_objects_folder" {
  bucket = var.s3_bucket_name
  prefix = "${var.folder_name}/"
  depends_on = [aws_s3_object.upload_file]
}