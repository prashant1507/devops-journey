output "bucket_name" {
  description = "The name of the MinIO bucket"
  value       = aws_s3_bucket.minio_bucket.bucket
}
