# Generate a Random Suffix for Instance Tag
resource "random_string" "suffix" {
  length  = 6
  special = false
  upper   = false
}

# Local Variable for Instance Tag
locals {
  # instance_name = "ec2-instance-${random_string.suffix.result}"
  instance_name = "ec2-instance" # This will support only count = 1 from ./terraform_aws_project/main.tf
  key_name = "${local.instance_name}-pkey"
  eip = "${local.instance_name}-eip"
}

# Generate an SSH Private Key
resource "tls_private_key" "private_key" {
  algorithm = "RSA"
  rsa_bits  = 2048
}

# Create an SSH Key Pair in AWS
resource "aws_key_pair" "key_pair" {
  key_name   = local.key_name
  # public_key = tls_private_key.private_key.public_key_openssh # Uncomment the following line to generate new key pair
  public_key = file(var.public_key_path) 
  tags = {
    Name = local.key_name
  }
}

# Create an EC2 Instance
resource "aws_instance" "ec2_instance" {
  ami                         = var.ami
  instance_type               = var.instance_type
  key_name                    = local.key_name
  subnet_id                   = var.subnet_id
  vpc_security_group_ids      = [var.security_group_id]
  associate_public_ip_address = var.associate_public_ip_address  # Disable public IP association

  tags = {
    Name = local.instance_name
  }
  depends_on = [aws_key_pair.key_pair]
}

# Elastic IP (Optional, Paid Service). Uncomment the following resources if you want to use an Elastic IP.
# Create an Elastic IP Address
resource "aws_eip" "elastic_ip" {
  count = var.create_and_associate_eip ? 1 : 0 # Will create elastic ip if true
  domain = "vpc"  # Required for VPC-based EIPs
  tags = {
    Name = local.eip
  }
}

# Associate the Elastic IP Address with the EC2 Instance
resource "aws_eip_association" "associate_elastic_ip" {
  count = var.create_and_associate_eip ? 1 : 0 # Will associate elastic ip if true
  instance_id   = aws_instance.ec2_instance.id
  allocation_id = aws_eip.elastic_ip[0].id
  depends_on    = [aws_eip.elastic_ip]
}