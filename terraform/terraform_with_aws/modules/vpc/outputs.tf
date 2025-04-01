# VPC ID
output "vpc_id" {
  value       = aws_vpc.vpc.id
  description = "The ID of the created VPC."
}

# Security Group ID
output "security_group_id" {
  value       = aws_security_group.security_group.id
  description = "The ID of the created Security Group."
}

# Private Subnet 1a ID
output "private_subnet_1a" {
  value       = aws_subnet.private_subnet_1a.id
  description = "The ID of the private subnet in availability zone 1a."
}

# Public Subnet 1a ID
output "public_subnet_1a" {
  value       = aws_subnet.public_subnet_1a.id
  description = "The ID of the public subnet in availability zone 1a."
}

# Private Subnet 1b ID
output "private_subnet_1b" {
  value       = aws_subnet.private_subnet_1b.id
  description = "The ID of the private subnet in availability zone 1b."
}

# Public Subnet 1b ID
output "public_subnet_1b" {
  value       = aws_subnet.public_subnet_1b.id
  description = "The ID of the public subnet in availability zone 1b."
}