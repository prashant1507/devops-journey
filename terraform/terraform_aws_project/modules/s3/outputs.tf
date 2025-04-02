output "s3_bucket_id" {
  value       = aws_s3_bucket.s3_bucket.id
  description = "The unique identifier of the S3 bucket."
}

output "s3_bucket_arn" {
  value       = aws_s3_bucket.s3_bucket.arn
  description = "The Amazon Resource Name (ARN) of the S3 bucket."
}

output "s3_bucket_name" {
  value       = aws_s3_bucket.s3_bucket.bucket
  description = "The name of the S3 bucket."
}

output "s3_folder_files" {
  value       = data.aws_s3_objects.s3_objects_buckets.keys
  description = "A list of files in the specified folder within the S3 bucket."
  depends_on  = [data.aws_s3_objects.s3_objects_folder]
}