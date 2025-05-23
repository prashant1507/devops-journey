variable "task_name" {
  description = "The name of the project or task being deployed"
  type        = string
  default     = "terraform_using_aws"
}

variable "aws_region" {
  description = "The AWS region where resources will be deployed"
  type        = string
  default     = "us-east-1" # Default region if not provided in terraform.tfvars
}

variable "instance_type" {
  description = "Instance Type"
  type        = string
}

variable "debian" {
  description = "Debian 12"
  type = string
  default = "ami-084568db4383264d4"
}

variable "environment_type" {
  description = "Environment: dev, stage, prod"
  type        = map(string)
  default = {
    "dev"   = "ami-0779caf41f9ba54f0" # Ubuntu Server 24.04 LTS (HVM), SSD Volume Type
    "stage" = "ami-0c15e602d3d6c6c4a" # Red Hat Enterprise Linux version 9 (HVM), EBS General Purpose (SSD) Volume Type,
    "prod"  = "ami-04b7f73ef0b798a0f" # SUSE Linux Enterprise Server 15 Service Pack 6 (HVM), EBS General Purpose (SSD) Volume Type. Amazon EC2 AMI Tools preinstalled.
  }
}