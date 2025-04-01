# Check if a specific file exists in the S3 bucket folder
output "is_file_present" {
  value       = contains(data.aws_s3_objects.s3_objects_folder.keys, "${var.folder_name}/dummy-file-upload-by-iam-user.txt")
  description = "Indicates whether the file 'dummy-file-upload-by-iam-user.txt' exists in the specified S3 folder."
  depends_on  = [aws_s3_object.upload_file]
}

# IAM User Login Password
output "user_password" {
  value       = aws_iam_user_login_profile.user_profile.password
  description = "The password for the IAM user login profile."
  sensitive   = true
}