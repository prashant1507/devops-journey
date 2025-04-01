output "aws_region" {
  value       = var.aws_region
  description = "The AWS region where the resources are deployed."
  sensitive   = false
}

output "vpc_id" {
  value       = module.vpc.vpc_id
  description = "The ID of the created VPC."
  depends_on  = [module.vpc]
}

output "ec2_id" {
  value       = [for instance in module.ec2 : instance.ec2_id]
  description = "The ID of the created EC2 instance."
  depends_on  = [module.ec2]
}

output "list_s3_bucket" {
  value       = module.s3.s3_folder_files
  description = "A list of folders and files in the S3 bucket."
  depends_on  = [module.s3]
}

output "is_file_present" {
  value       = module.iam.is_file_present
  description = "Indicates whether a specific file is present in the S3 bucket."
  depends_on  = [module.iam]
}