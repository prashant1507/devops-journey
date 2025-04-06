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

variable "associate_public_ip_address" {
  description = "Assign public IP to ec2 instance"
  type = bool
}

variable "create_and_associate_eip" {
  description = "Create and associate public ip to ec2"
  type = bool
}

variable "public_key_path" {
  description = "Path to the public key file for SSH access."
  type        = string
  default     = "~/.ssh/id_rsa.pub"
  validation {
    condition     = fileexists(var.public_key_path)
    error_message = "The public key file does not exist at the specified path."
  }
  sensitive = true
}