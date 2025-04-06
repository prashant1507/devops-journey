terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "5.93.0"
    }
  }

  # backend "s3" {
  #   bucket         = "tfstate-bucket-name"
  #   key            = "terraform.tfstate"
  #   region         = var.region
  #   encrypt        = true
  #   dynamodb_table = "tfstate-dynamodb-table"
  # }

}

module "vpc" {
  source    = "./modules/vpc"
  task_name = var.task_name
}

module "ec2" {
  count                       = 1 # create X similar EC2 instances
  source                      = "./modules/ec2"
  ami                         = lookup(var.environment_type, terraform.workspace, "ami-0779caf41f9ba54f0")
  instance_type               = var.instance_type
  security_group_id           = module.vpc.security_group_id
  subnet_id                   = module.vpc.public_subnet_1a
  depends_on                  = [module.vpc]
  associate_public_ip_address = false
  create_and_associate_eip    = false
}

module "s3" {
  source      = "./modules/s3"
  bucket_name = "test-bucket"
}

module "iam" {
  source         = "./modules/iam"
  s3_bucket_name = module.s3.s3_bucket_name
  s3_bucket_id   = module.s3.s3_bucket_id
  s3_bucket_arn  = module.s3.s3_bucket_arn
  folder_name    = "test-bucket-folder"
  depends_on     = [module.s3]
}

# module "load_balancer" {
#   source            = "./modules/load_balancer"
#   security_group_id = module.vpc.security_group_id
#   private_subnets   = [module.vpc.private_subnet_1a, module.vpc.private_subnet_1b]
#   vpc_id            = module.vpc.vpc_id
#   ami               = lookup(var.environment_type, terraform.workspace, "ami-0779caf41f9ba54f0")
#   instance_type     = var.instance_type
#   depends_on        = [module.vpc]
# }
