variable "minio_url" {
  description = "The URL of the MinIO server. Example: http://minio.example.com"
  type        = string

  validation {
    condition     = can(regex("^https?://[a-zA-Z0-9.-]+(:[0-9]+)?(/.*)?$", var.minio_url))
    error_message = "The MinIO URL must be a valid HTTP or HTTPS URL."
  }

  default = "http://localhost:9000" # Default value for local testing
}

variable "region" {
  description = "The region for the MinIO provider. This is a dummy value since MinIO does not require a region."
  type        = string
  default     = "us-east-1" # Dummy region (needed for AWS provider)
  validation {
    condition     = length(var.region) > 0
    error_message = "The region cannot be empty."
  }
}

variable "access_key" {
  description = "The access key for MinIO. Read as environment variable."
  type        = string

  validation {
    condition     = length(var.access_key) > 0
    error_message = "The access key cannot be empty."
  }
}

variable "secret_key" {
  description = "The secret key for MinIO. Read as environment variable."
  type        = string

  validation {
    condition     = length(var.secret_key) > 0
    error_message = "The secret key cannot be empty."
  }
  sensitive = true

}

variable "aws_s3_force_path_style" {
  default = "true"
}