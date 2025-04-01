# Use Cases

### Table of COntents

1. [Multi-Cloud Infrastructure Management](#1-multi-cloud-infrastructure-management)
2. [Infrastructure as Code for a Web Application](#2-infrastructure-as-code-for-a-web-application)
3. [Continuous Deployment Pipeline](#3-continuous-deployment-pipeline)
4. [Auto Scaling with Load Balancer](#4-auto-scaling-with-load-balancer)
5. [Backup Strategy Using AWS S3](#5-backup-strategy-using-aws-s3)
6. [Managing DNS Records with Route 53](#6-managing-dns-records-with-route-53)
7. [Infrastructure with Auto-Scaling for a Database](#7-infrastructure-with-auto-scaling-for-a-database)
8. [Creating a Secure VPC with Network Segmentation](#8-creating-a-secure-vpc-with-network-segmentation)
9. [Setting Up CI/CD Pipeline on AWS](#9-setting-up-cicd-pipeline-on-aws)

---

### **1. Multi-Cloud Infrastructure Management**
**Q:** How can I manage infrastructure across multiple cloud providers (e.g., AWS, Azure, GCP) using Terraform?  
**A:** Terraform allows you to define infrastructure for multiple cloud providers in a single configuration file. By defining separate providers for each cloud, you can manage resources across AWS, Azure, and GCP seamlessly.

**Example:**
```hcl
# AWS Provider
provider "aws" {
  region = "us-east-1"
}

# Azure Provider
provider "azurerm" {
  features {}
}

# Google Cloud Provider
provider "google" {
  project = "your-project-id"
  region  = "us-central1"
}

resource "aws_s3_bucket" "aws_bucket" {
  bucket = "aws-example-bucket"
}

resource "azurerm_storage_account" "azure_storage" {
  name                     = "azureexamplestorage"
  resource_group_name      = "example-resources"
  location                 = "East US"
  account_tier              = "Standard"
  account_replication_type = "LRS"
}

resource "google_storage_bucket" "gcp_bucket" {
  name          = "gcp-example-bucket"
  location      = "US"
  storage_class = "STANDARD"
}
```

---

### **2. Infrastructure as Code for a Web Application**
**Q:** How can I set up an infrastructure for a web application using Terraform?  
**A:** Terraform can provision all the resources needed for a web application, including VPC, security groups, load balancers, EC2 instances, and databases. Here's an example of setting up the basic infrastructure for a web application on AWS.

**Example:**
```hcl
# AWS Provider
provider "aws" {
  region = "us-east-1"
}

# VPC
resource "aws_vpc" "web_vpc" {
  cidr_block = "10.0.0.0/16"
}

# Subnet
resource "aws_subnet" "web_subnet" {
  vpc_id                  = aws_vpc.web_vpc.id
  cidr_block              = "10.0.1.0/24"
  availability_zone       = "us-east-1a"
}

# Security Group
resource "aws_security_group" "web_sg" {
  vpc_id = aws_vpc.web_vpc.id
  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

# EC2 Instance
resource "aws_instance" "web_instance" {
  ami           = "ami-0c55b159cbfafe1f0"
  instance_type = "t2.micro"
  subnet_id     = aws_subnet.web_subnet.id
  security_group_ids = [aws_security_group.web_sg.id]
}

# Load Balancer
resource "aws_lb" "web_lb" {
  name               = "web-alb"
  internal           = false
  load_balancer_type = "application"
  security_groups   = [aws_security_group.web_sg.id]
  subnets           = [aws_subnet.web_subnet.id]
}

# Target Group
resource "aws_lb_target_group" "web_target_group" {
  name     = "web-target-group"
  port     = 80
  protocol = "HTTP"
  vpc_id   = aws_vpc.web_vpc.id
}

# Listener
resource "aws_lb_listener" "web_listener" {
  load_balancer_arn = aws_lb.web_lb.arn
  port              = 80
  protocol          = "HTTP"
  default_action {
    target_group_arn = aws_lb_target_group.web_target_group.arn
    type             = "forward"
  }
}
```

---

### **3. Continuous Deployment Pipeline**
**Q:** How can I set up infrastructure for a Continuous Deployment (CD) pipeline using Terraform?  
**A:** Terraform can be used to automate the creation of resources like code repositories, pipelines, and deployment environments. For example, setting up an AWS CodePipeline for continuous deployment.

**Example:**
```hcl
# AWS Provider
provider "aws" {
  region = "us-west-2"
}

# CodeCommit Repository
resource "aws_codecommit_repository" "repo" {
  repository_name = "my-app-repo"
  description     = "My Application's Code"
}

# CodeBuild Project
resource "aws_codebuild_project" "build_project" {
  name          = "my-app-build"
  description   = "Build project for my application"
  service_role  = aws_iam_role.codebuild_role.arn
  environment {
    compute_type = "BUILD_GENERAL1_SMALL"
    image        = "aws/codebuild/standard:4.0"
    type         = "LINUX_CONTAINER"
  }
}

# CodePipeline
resource "aws_codepipeline" "pipeline" {
  name     = "my-app-pipeline"
  role_arn = aws_iam_role.codepipeline_role.arn

  artifact_store {
    type     = "S3"
    location = "my-pipeline-artifacts-bucket"
  }

  stage {
    name = "Source"
    action {
      name             = "Source"
      category         = "Source"
      owner            = "AWS"
      provider         = "CodeCommit"
      version          = "1"
      output_artifacts = ["source_output"]
      configuration = {
        RepositoryName = aws_codecommit_repository.repo.repository_name
        BranchName     = "master"
      }
    }
  }

  stage {
    name = "Build"
    action {
      name             = "Build"
      category         = "Build"
      owner            = "AWS"
      provider         = "CodeBuild"
      version          = "1"
      input_artifacts  = ["source_output"]
      output_artifacts = ["build_output"]
      configuration = {
        ProjectName = aws_codebuild_project.build_project.name
      }
    }
  }

  stage {
    name = "Deploy"
    action {
      name             = "Deploy"
      category         = "Deploy"
      owner            = "AWS"
      provider         = "CodeDeploy"
      version          = "1"
      input_artifacts  = ["build_output"]
      output_artifacts = []
    }
  }
}
```

---

### **4. Auto Scaling with Load Balancer**
**Q:** How can I deploy a highly available web application across multiple availability zones using Terraform?  
**A:** Terraform can help deploy a web application with redundancy across multiple availability zones by provisioning a load balancer, multiple EC2 instances in different subnets (across multiple AZs), and configuring auto-scaling for high availability.

**Example:**
```hcl
# AWS Provider
provider "aws" {
  region = "us-west-2"
}

# VPC Creation
resource "aws_vpc" "main" {
  cidr_block = "10.0.0.0/16"
}

# Subnets for High Availability (across 2 AZs)
resource "aws_subnet" "subnet_a" {
  vpc_id                  = aws_vpc.main.id
  cidr_block              = "10.0.1.0/24"
  availability_zone       = "us-west-2a"
}

resource "aws_subnet" "subnet_b" {
  vpc_id                  = aws_vpc.main.id
  cidr_block              = "10.0.2.0/24"
  availability_zone       = "us-west-2b"
}

# Security Group for EC2 Instances
resource "aws_security_group" "web_sg" {
  vpc_id = aws_vpc.main.id
  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

# Load Balancer for the Web App
resource "aws_lb" "web_lb" {
  name               = "web-app-lb"
  internal           = false
  load_balancer_type = "application"
  security_groups   = [aws_security_group.web_sg.id]
  subnets           = [aws_subnet.subnet_a.id, aws_subnet.subnet_b.id]
}

# Auto Scaling Group (ASG)
resource "aws_launch_configuration" "web_config" {
  name = "web-app-config"
  image_id = "ami-0c55b159cbfafe1f0"  # Replace with your AMI ID
  instance_type = "t2.micro"
  security_groups = [aws_security_group.web_sg.id]
}

resource "aws_autoscaling_group" "web_asg" {
  desired_capacity     = 2
  max_size             = 4
  min_size             = 2
  vpc_zone_identifier  = "${aws_subnet.subnet_a.id},${aws_subnet.subnet_b.id}"
  launch_configuration = aws_launch_configuration.web_config.id
  target_group_arns    = [aws_lb_target_group.web_target_group.arn]
}
```

**Explanation:**  
- This configuration creates a VPC, two subnets (one in each Availability Zone), a security group, a load balancer, and an auto-scaling group (ASG) to ensure the web application is highly available and can scale according to demand.

---

### **5. Backup Strategy Using AWS S3**
**Q:** How can I automate backups using Terraform?  
**A:** Terraform can automate backup creation by creating scheduled snapshots, copying files to S3 buckets, and managing retention policies.

**Example:**
```hcl
# AWS Provider
provider "aws" {
  region = "us-east-1"
}

# S3 Bucket for Backup
resource "aws_s3_bucket" "backup" {
  bucket = "my-backup-bucket"
  acl    = "private"
}

# IAM Role for Lambda to perform backups
resource "aws_iam_role" "lambda_role" {
  name = "lambda-backup-role"
  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Principal = {
          Service = "lambda.amazonaws.com"
        }
      }
    ]}
  )}
```

---

### **6. Managing DNS Records with Route 53**

**Q:** How can I manage DNS records using AWS Route 53 with Terraform?  
**A:** You can create and manage DNS records, including A, CNAME, and TXT records, in AWS Route 53 using Terraform. It allows you to automate the DNS management as part of your infrastructure.

**Example:**
```hcl
# AWS Provider
provider "aws" {
  region = "us-east-1"
}

# Route 53 Hosted Zone
resource "aws_route53_zone" "example_zone" {
  name = "example.com"
}

# Route 53 A Record (Pointing to an ELB)
resource "aws_route53_record" "example_a_record" {
  zone_id = aws_route53_zone.example_zone.id
  name    = "www"
  type    = "A"
  ttl     = 300
  records = [aws_lb.web_lb.dns_name]
}

# Route 53 CNAME Record
resource "aws_route53_record" "example_cname" {
  zone_id = aws_route53_zone.example_zone.id
  name    = "app"
  type    = "CNAME"
  ttl     = 300
  records = ["app.example.com"]
}
```

**Explanation:**  
- This configuration creates a hosted zone in Route 53 and two records: an A record pointing to an Elastic Load Balancer and a CNAME record.

---

### **7. Infrastructure with Auto-Scaling for a Database**

**Q:** How can I deploy a scalable MySQL database on AWS using Terraform?  
**A:** Terraform can be used to create an RDS instance with auto-scaling capabilities, ensuring the database scales horizontally and vertically to handle growing application traffic.

**Example:**
```hcl
# AWS Provider
provider "aws" {
  region = "us-west-2"
}

# RDS MySQL Instance
resource "aws_db_instance" "mysql_db" {
  engine               = "mysql"
  instance_class       = "db.t2.micro"
  name                 = "mydb"
  username             = "admin"
  password             = "password"
  allocated_storage    = 20
  multi_az             = true
  storage_type         = "gp2"
  publicly_accessible  = false
  backup_retention_period = 7
}

# RDS Read Replica for Scaling
resource "aws_db_instance" "mysql_read_replica" {
  engine                = "mysql"
  instance_class        = "db.t2.micro"
  publicly_accessible   = false
  replicate_source_db   = aws_db_instance.mysql_db.id
  availability_zone     = "us-west-2b"
  storage_type          = "gp2"
}
```

**Explanation:**  
- In this example, an RDS MySQL instance is provisioned along with a read replica to scale horizontally, ensuring that both read and write requests are distributed to maintain optimal performance.

---

### **8. Creating a Secure VPC with Network Segmentation**

**Q:** How can I create a secure VPC with public and private subnets using Terraform?  
**A:** Terraform allows you to create a VPC with both public and private subnets to securely segment your network. Resources like EC2 instances or databases can be placed in different subnets based on their access requirements.

**Example:**
```hcl
# AWS Provider
provider "aws" {
  region = "us-west-2"
}

# VPC
resource "aws_vpc" "secure_vpc" {
  cidr_block = "10.0.0.0/16"
}

# Public Subnet
resource "aws_subnet" "public_subnet" {
  vpc_id                  = aws_vpc.secure_vpc.id
  cidr_block              = "10.0.1.0/24"
  availability_zone       = "us-west-2a"
  map_public_ip_on_launch = true
}

# Private Subnet
resource "aws_subnet" "private_subnet" {
  vpc_id                  = aws_vpc.secure_vpc.id
  cidr_block              = "10.0.2.0/24"
  availability_zone       = "us-west-2a"
  map_public_ip_on_launch = false
}

# Internet Gateway for Public Subnet
resource "aws_internet_gateway" "public_igw" {
  vpc_id = aws_vpc.secure_vpc.id
}

# NAT Gateway for Private Subnet
resource "aws_nat_gateway" "private_nat" {
  allocation_id = aws_eip.nat.id
  subnet_id     = aws_subnet.public_subnet.id
}

# Elastic IP for NAT Gateway
resource "aws_eip" "nat" {
  vpc = true
}
```

**Explanation:**  
- This setup creates a VPC with a public and a private subnet. The public subnet is used for resources that need internet access, while the private subnet hosts resources like databases that should not be directly accessible from the internet. The NAT Gateway is used to provide outbound internet access for resources in the private subnet.

---

### **9. Setting Up CI/CD Pipeline on AWS**

**Q:** How can I set up a CI/CD pipeline for deploying a web application using AWS CodePipeline with Terraform?  
**A:** Terraform can automate the creation of resources for setting up a complete CI/CD pipeline using AWS services like CodeCommit, CodeBuild, CodeDeploy, and CodePipeline.

**Example:**
```hcl
# AWS Provider
provider "aws" {
  region = "us-east-1"
}

# CodeCommit Repository
resource "aws_codecommit_repository" "repo" {
  repository_name = "my-web-app"
  description     = "Web Application Repository"
}

# CodeBuild Project
resource "aws_codebuild_project" "build" {
  name          = "web-app-build"
  description   = "Build project for web app"
  service_role  = aws_iam_role.codebuild_role.arn
  environment {
    compute_type = "BUILD_GENERAL1_SMALL"
    image        = "aws/codebuild/standard:4.0"
    type         = "LINUX_CONTAINER"
  }
}

# CodePipeline
resource "aws_codepipeline" "pipeline" {
  name     = "web-app-pipeline"
  role_arn = aws_iam_role.codepipeline_role.arn

  artifact_store {
    type     = "S3"


    location = "my-pipeline-artifacts-bucket"
  }

  stage {
    name = "Source"
    action {
      name             = "Source"
      category         = "Source"
      owner            = "AWS"
      provider         = "CodeCommit"
      version          = "1"
      output_artifacts = ["source_output"]
      configuration = {
        RepositoryName = aws_codecommit_repository.repo.repository_name
        BranchName     = "master"
      }
    }
  }

  stage {
    name = "Build"
    action {
      name             = "Build"
      category         = "Build"
      owner            = "AWS"
      provider         = "CodeBuild"
      version          = "1"
      input_artifacts  = ["source_output"]
      output_artifacts = ["build_output"]
      configuration = {
        ProjectName = aws_codebuild_project.build.name
      }
    }
  }

  stage {
    name = "Deploy"
    action {
      name             = "Deploy"
      category         = "Deploy"
      owner            = "AWS"
      provider         = "CodeDeploy"
      version          = "1"
      input_artifacts  = ["build_output"]
      output_artifacts = []
    }
  }
}
```

**Explanation:**  
- This configuration sets up a CI/CD pipeline using AWS CodePipeline, with a CodeCommit repository as the source, CodeBuild for building the application, and CodeDeploy for deploying it. The pipeline automates the process of deploying changes to your application.

