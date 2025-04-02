provider "aws" {
  # alias = "minio-provider"
  access_key = var.access_key
  secret_key = var.secret_key
  region     = "us-east-1"  # Dummy value, required by AWS provider

  endpoints {
    s3 = var.minio_url  # Example: "http://localhost:9000"
  }

  s3_force_path_style = true
  skip_credentials_validation = true # Skips AWS-specific credential checks.
  skip_metadata_api_check     = true # Disables AWS metadata API checks.
  skip_requesting_account_id  = true # Prevents account ID requests.
}