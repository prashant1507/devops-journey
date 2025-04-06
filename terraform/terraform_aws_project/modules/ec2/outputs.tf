output "ec2_id" {
  value       = aws_instance.ec2_instance.id
  description = "The ID of the created EC2 instance."
}

# output "ec2_ip" {
#   value = aws_eip.elastic_ip.public_ip
#   description = "The public IP address of the created EC2 instance."
# }