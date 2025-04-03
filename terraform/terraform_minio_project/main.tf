# Terraform Configuration
terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "5.93.0" # For now using this untill find a replace for s3_force_path_style in providers.tf
    }
  }
  required_version = ">= 1.5.0" # Specify the minimum Terraform version
}


# MinIO Module
module "minio" {
  source      = "./modules/minio" # Path to the MinIO module
  minio_url   = var.minio_url     # MinIO server URL
  bucket_name = "minio-bucket"    # Name of the bucket to be created
  folder_name = "minio-folder"    # Name of the folder inside the bucket
}

