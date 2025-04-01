output "ec2_id" {
  value       = aws_instance.ec2_instance.id
  description = "The ID of the created EC2 instance."
}