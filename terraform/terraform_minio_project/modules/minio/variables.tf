variable "bucket_name" {
  description = "The name of the MinIO bucket. Must be unique and follow S3 bucket naming conventions."
  type        = string

  validation {
    condition     = can(regex("^[a-z0-9.-]{3,63}$", var.bucket_name))
    error_message = "The bucket name must be between 3 and 63 characters, and can only contain lowercase letters, numbers, dots, and hyphens."
  }
}

variable "folder_name" {
  description = "The name of the folder to create in the MinIO bucket. Must not be empty."
  type        = string

  validation {
    condition     = length(var.folder_name) > 0
    error_message = "The folder name cannot be empty."
  }
}

variable "minio_url" {
  description = "The URL of the MinIO server. Example: http://minio.example.com"
  type        = string

  validation {
    condition     = can(regex("^https?://[a-zA-Z0-9.-]+(:[0-9]+)?(/.*)?$", var.minio_url))
    error_message = "The MinIO URL must be a valid HTTP or HTTPS URL."
  }

  default = "http://localhost:9000" # Default value for local testing
}