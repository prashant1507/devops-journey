variable "ami" {
  description = "The Amazon Machine Image (AMI) ID to use for the EC2 instance."
  type        = string
}

variable "instance_type" {
  description = "The type of EC2 instance to launch (e.g., t2.micro, t3.medium)."
  type        = string
  default     = "t2.micro"
  validation {
    condition     = contains(["t2.micro", "t3.micro", "t3.medium", "t3.large"], var.instance_type)
    error_message = "The instance type must be one of t2.micro, t3.micro, t3.medium, or t3.large."
  }
}

variable "security_group_id" {
  description = "The ID of the security group to associate with the EC2 instance."
  type        = string
}

variable "subnet_id" {
  description = "The ID of the subnet where the EC2 instance will be launched."
  type        = string
}