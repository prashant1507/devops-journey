output "ec2_id" {
  value       = aws_instance.ec2_instance.id
  description = "The ID of the created EC2 instance."
}

output "ec2_ip" {
  value = length(aws_eip.elastic_ip) > 0 ? aws_eip.elastic_ip[0].public_ip : var.create_and_associate_eip
  description = "The public IP address of the created EC2 instance."
}