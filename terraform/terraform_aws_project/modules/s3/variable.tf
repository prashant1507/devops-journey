variable "bucket_name" {
  description = "The name of the S3 bucket to be created. Must be globally unique."
  type        = string
  default     = "test-bucket"
  validation {
    condition     = length(var.bucket_name) > 3 && length(var.bucket_name) <= 63
    error_message = "The bucket name must be between 3 and 63 characters long."
  }
}

variable "folder_name" {
  description = "The name of the folder to be created inside the S3 bucket."
  type        = string
  default     = "test-bucket-folder"
  validation {
    condition     = length(var.folder_name) > 0
    error_message = "The folder name cannot be empty."
  }
}