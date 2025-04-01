variable "task_name" {
  description = "The name of the project or task being deployed"
  type        = string
  default     = "terraform_using_aws"
}

variable "aws_region" {
  description = "The AWS region where resources will be deployed"
  type        = string
  default     = "us-east-1"  # Default region if not provided in terraform.tfvars
}