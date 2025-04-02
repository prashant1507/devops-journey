output "minio_bucket_name" {
  description = "The name of the MinIO bucket"
  value       = module.minio.bucket_name
}
