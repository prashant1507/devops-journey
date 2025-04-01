terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "5.93.0"
    }
  }
}

# VPC Module
module "vpc" {
  source    = "./modules/vpc"
  task_name = var.task_name
}

# EC2 Module
module "ec2" {
  count             = 1 # create X similar EC2 instances
  source            = "./modules/ec2"
  ami               = lookup(var.environment_type, terraform.workspace, "ami-0779caf41f9ba54f0")
  instance_type     = "t2.micro"
  security_group_id = module.vpc.security_group_id
  subnet_id         = module.vpc.public_subnet_1a
  depends_on        = [module.vpc]
}

# S3 Module
module "s3" {
  source      = "./modules/s3"
  bucket_name = "test-bucket"
}

# IAM Module
module "iam" {
  source         = "./modules/iam"
  s3_bucket_name = module.s3.s3_bucket_name
  s3_bucket_id   = module.s3.s3_bucket_id
  s3_bucket_arn  = module.s3.s3_bucket_arn
  folder_name    = "test-bucket-folder"
  depends_on     = [module.s3]
}

# Load Balancer Module
module "load_balancer" {
  source         = "./modules/load_balancer"

}
