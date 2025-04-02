variable "user_name" {
  description = "The name of the IAM user to be created."
  type        = string
  default     = "test-user-1"
  validation {
    condition     = length(var.user_name) > 0
    error_message = "The IAM user name cannot be empty."
  }
}

variable "s3_bucket_id" {
  description = "The unique identifier of the S3 bucket."
  type        = string
}

variable "s3_bucket_name" {
  description = "The name of the S3 bucket."
  type        = string
  validation {
    condition     = length(var.s3_bucket_name) > 3 && length(var.s3_bucket_name) <= 63
    error_message = "The S3 bucket name must be between 3 and 63 characters long."
  }
}

variable "s3_bucket_arn" {
  description = "The Amazon Resource Name (ARN) of the S3 bucket."
  type        = string
}

variable "folder_name" {
  description = "The name of the folder to be created in the S3 bucket."
  type        = string
  validation {
    condition     = length(var.folder_name) > 0
    error_message = "The folder name cannot be empty."
  }
}