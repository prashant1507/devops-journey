variable "security_group_id" {
  description = "Security group ID for the load balancer"
  type        = string
  validation {
    condition     = length(var.security_group_id) > 0
    error_message = "The security group ID must not be empty."
  }
}

variable "private_subnets" {
  description = "List of private subnets for the load balancer"
  type        = list(string)
  validation {
    condition     = length(var.private_subnets) > 0
    error_message = "At least one private subnet must be provided."
  }
}

variable "vpc_id" {
  description = "VPC ID for the load balancer"
  type        = string
  validation {
    condition     = length(var.vpc_id) > 0
    error_message = "The VPC ID must not be empty."
  }
}

variable "ami" {
  description = "AMI ID for the EC2 instances"
  type        = string
}

variable "instance_type" {
  description = "Instance type for the EC2 instances"
  type        = string
  validation {
    condition     = length(var.instance_type) > 0
    error_message = "The instance type must not be empty."
  }
}