# Terraform with AWS

### Table of Contents
1. [Overview](#overview)
2. [Folder Structure](#folder-structure)
3. [Prerequisites](#prerequisites)
4. [Using Terraform Workspaces](#using-terraform-workspaces)
5. [Modules Overview](#modules-overview)
   - [VPC Module](#vpc-module)
   - [EC2 Module](#ec2-module)
   - [S3 Module](#s3-module)
   - [IAM Module](#iam-module)
6. [Running Terraform](#running-terraform)
7. [Notes](#notes)
8. [Conclusion](#conclusion)
9. [Author](#author)
10. [References](#references)

---

### Overview
This repository contains Terraform configurations to provision and manage AWS resources using Infrastructure as Code (IaC). The project is structured into multiple modules including VPC, EC2, S3, IAM, and Load Balancing, making it easy to manage and scale AWS infrastructure. This also elloborates usage of remote backends to allow Terraform's state file to be stored remotely

---

### Folder Structure
```
terraform_aws_project/
│── modules/
│   ├── vpc/
│   │   ├── main.tf
│   │   ├── variables.tf
│   ├── ec2/
│   │   ├── main.tf
│   │   ├── variables.tf
│   │   ├── outputs.tf
│   ├── s3/
│   │   ├── main.tf
│   │   ├── variables.tf
│   │   ├── outputs.tf
│   ├── iam/
│   │   ├── main.tf
│   │   ├── variables.tf
│   │   ├── outputs.tf
│   ├── load_balancer/
│       ├── main.tf
│       ├── variables.tf
│       ├── outputs.tf
│── resources/
│   ├── vpc-resource-map.png
│   ├── dummy-file.txt
│   ├── Notes.md
│   ├── Use_Cases.md
|   ├── Offline-Terraform-Deployment.md
|   ├── Notes-Terraform-Import.md
│── main.tf
│── variables.tf
│── outputs.tf
│── terraform.tfvars
│── provifers.tf
│── README.md
```

---

### Prerequisites
1. **AWS Account** - Log in to AWS and generate credentials.
2. **Terraform Installed** - Install Terraform on your local machine.
3. **AWS Credentials** - Set environment variables for authentication:
   ```sh
   export AWS_ACCESS_KEY_ID=your_access_key
   export AWS_SECRET_ACCESS_KEY=your_secret_key
   ```
4. **Initialize Terraform**
   ```sh
   terraform init
   ```
---

### Using Terraform Workspaces
Terraform supports multiple environments using workspaces. To create or select a workspace:
```sh
terraform workspace new dev
terraform workspace select dev
```

---

### Modules Overview
### **VPC Module** (Refer to [vpc-resource-map.png](./resources/vpc-resource-map.png))
![vpc-resource-map.png](resources/vpc-resource-map.png)
1. **Create VPC:** Provision a new Virtual Private Cloud (VPC) for networking resources.

2. **Create Security Group**  
   - Define a security group with the following rules:
     - **Ingress Rules**: Allow incoming traffic on ports 22 (SSH), 80 (HTTP), and 443 (HTTPS).
     - **Egress Rules**: Allow all outbound traffic to any destination and for any protocol.

3. **Create Subnets:** Create **2 public subnets** and **2 private subnets** across multiple availability zones for high availability and fault tolerance.

4. **Create Internet Gateway:** Provision an internet gateway to provide internet access to the public subnet resources.

5. **Create Route Tables**  
   - Define **1 route table** for the public subnets and **2 route tables** for the private subnets.
   - Associate route tables with appropriate subnets for traffic management.

6. **Attach Internet Gateway to Public Route Table:** Attach the internet gateway to the public route table to ensure that instances in the public subnet can access the internet.

7. **Set Route Table Association:** Associate the appropriate route tables to the respective subnets, ensuring proper routing within the VPC.

8. **Create VPC for S3 Endpoint:** Create a dedicated VPC endpoint for Amazon S3, enabling secure communication between the VPC and S3 without the need for an internet gateway.

9. **Modify the VPC Endpoint:** Modify the VPC endpoint to add the private route tables to the S3 endpoint, allowing instances in the private subnets to access S3 securely.

### **EC2 Module**
1. **Create EC2 Instances Using `count = X` in [main.tf](main.tf)**  
   - Provision **X number of EC2 instances** by utilizing the `count` parameter in [main.tf](main.tf) within the EC2 module. This allows dynamic scaling of instances based on the specified count value.

2. **Create SSH Key Pair**  
   - Generate an SSH key pair to allow secure SSH access to the EC2 instances. The key pair will be used when connecting to the instances remotely.

3. **Create EC2 Instance with Disabled Public IP**  
   - By default, EC2 instances are created with **public IP addresses disabled**.  
   - To enable public IP assignment for an EC2 instance, update the `associate_public_ip_address` setting in [modules/ec2/main.tf](modules/ec2/main.tf) under the `aws_instance.ec2_instance` resource. Set `associate_public_ip_address = true` if public IPs are required.

4. **Create Elastic IP (EIP)**  
   - Optionally, create an **Elastic IP** by uncommenting the respective lines in [modules/ec2/main.tf](modules/ec2/main.tf). An Elastic IP is a static IP that can be associated with an EC2 instance for consistent public access.

5. **Assign Elastic IP to EC2 Instance**  
   - To assign the created Elastic IP to an EC2 instance, uncomment the relevant lines in [modules/ec2/main.tf](modules/ec2/main.tf). This allows the EC2 instance to be associated with a static IP address that persists even after instance restarts.

### **S3 Module**
1. **Create S3 Bucket:** Provision a new S3 bucket to store and manage objects securely.  

2. **Enable Versioning:** Activate versioning on the bucket to retain previous versions of objects, providing protection against accidental deletions or overwrites.  

3. **Block Public Access:**  Enforce security by blocking all public access to the bucket, ensuring that objects are not exposed to unauthorized users.  

4. **Create Folder in S3 Bucket:** Organize content by creating structured folders within the bucket for efficient data management.  

5. **Upload File:** Upload files to the specified folder in the S3 bucket for storage and retrieval.  

6. **Refresh Terraform State:** Update the Terraform state to reflect the latest changes after uploading files, ensuring consistency between the infrastructure and state file.  

7. **List Objects in a Specific Folder:** Retrieve a list of all objects within a particular folder inside the S3 bucket using Terraform's data source feature.  

8. **List All Objects in the S3 Bucket:** Fetch details of all objects stored in the entire S3 bucket for inventory or auditing purposes.  

9. **Download a Specific File from the S3 Bucket:** Retrieve a particular file from the S3 bucket for local use or further processing.  

### **IAM Module**
1. **Create IAM User Group:** Define a user group to manage permissions collectively for multiple IAM users.  

2. **Attach Predefined Policy to IAM User Group:** Grant the IAM user group full access to Amazon S3 by attaching the `AmazonS3FullAccess` policy.  

3. **Create IAM User:** Provision a new IAM user for secure access to AWS resources.  

4. **Attach a Login Profile (AWS Management Console Access):** Enable AWS Management Console login by attaching a login profile to the IAM user.  

5. **Add IAM User to Group:** Assign the IAM user to the previously created IAM group to inherit permissions.  

6. **Grant Full Access to S3 for IAM User:** Ensure the IAM user has full access to Amazon S3, either through direct policies or inherited group permissions.  

7. **Upload a File to the Folder in the S3 Bucket:** Test S3 access by uploading a file to a specific folder within the bucket.  

8. **Verify if the File is Uploaded in the S3 Folder:** Confirm that the uploaded file appears in the specified S3 bucket folder.  


### **Load Balancer Module**
1. **Create an Internal Application Load Balancer (ALB)**

2. **Create a Target Group:** Listens on **port 80** with **HTTP protocol**

3. **Create an ALB Listener:** Listens on **port 80 (HTTP)**. Uses **"forward" action** to send traffic to the **Target Group**.

4. **Create a Launch Template**

5. **Create an Auto Scaling Group (ASG)**
    - **`aws_autoscaling_group "asg"`** creates an ASG with:
      - **Min instances:** `1`
      - **Max instances:** `3`
      - **Desired capacity:** `2`
    - Uses the **private subnets (`var.private_subnets`)**.
    - Configured **health check type: `ELB`** (Uses ALB health checks).
    - Health check grace period: **30 seconds**.
    - **Automatically registers instances** with the **ALB Target Group**.
    - Uses the **Launch Template** to create EC2 instances.

---

### Running Terraform
```sh
export AWS_ACCESS_KEY_ID=your_access_key
export AWS_SECRET_ACCESS_KEY=your_secret_key
terraform init
terraform workspace new <workspace> # Create workspace [dev, stage, prod], add more env in [variables.tf]
terraform workspace select <workspace> # Switch between environments
terraform plan    # Preview changes
terraform apply   # Apply changes
terraform destroy # Destroy resources
```
---

### Notes
- Refer Useful Notes and Info: [Useful Info and Questions](resources/Notes.md)
- Refer use cases: [Use_Cases.md](resources/Use_Cases.md)
- Offline Terraform Setup: [Offline-Terraform-Deployment](resources/Offline-Terraform-Deployment.md)
- Terraform Import related questions, use cases, hands-on: [Terraform-Imports](resources/Notes-Terraform-Import.md)
- Modify `terraform.tfvars` for specific configurations.
- Uncomment `backend` in `main.tf -> terraform` to store tfstate file in S3
   - Follow [link](https://spacelift.io/blog/terraform-s3-backend) to setup bucket and dynamodb_table in AWS
- AMI used as below:
   - dev: ami-084568db4383264d4
      - Ubuntu Server 24.04 LTS (HVM), SSD Volume Type
   - stage: ami-0c15e602d3d6c6c4a
      - Red Hat Enterprise Linux version 9 (HVM), EBS General Purpose (SSD) Volume Type,
   - prod: ami-04b7f73ef0b798a0f
      - SUSE Linux Enterprise Server 15 Service Pack 6 (HVM), EBS General Purpose (SSD) Volume Type. Amazon EC2 AMI Tools preinstalled.
   - default: ami-0779caf41f9ba54f0
      - Debian 12 (HVM), EBS General Purpose (SSD) Volume Type. Community developed free GNU/Linux distribution

---

### Conclusion
This repository provides a structured approach to deploying AWS infrastructure using Terraform.

---

### Author
This project is created for Terraform practice and learning purposes.

---

### References
- **Terraform Course Playlist:** [Terraform Zero to Hero - YouTube](https://youtube.com/playlist?list=PLdpzxOOAlwvI0O4PeKVV1-yJoX2AqIWuf&si=Yv0N00EHJc0FAaCT)
- **Course Git Notes:** [Terraform Zero to Hero - GitHub](https://github.com/iam-veeramalla/terraform-zero-to-hero)
- **Terraform AWS Documentation:** [AWS Provider Documentation](https://registry.terraform.io/providers/hashicorp/aws/latest/docs)
- **Terraform VSphere Documentation:** [VSphere Provider Documentation](https://registry.terraform.io/providers/hashicorp/vsphere/latest/docs)
- **Terraform Language Documentation:** [Terraform Language](https://developer.hashicorp.com/terraform/language)
- **AWS Course Playlist:** [AWS Projects - YouTube](https://youtube.com/playlist?list=PLdpzxOOAlwvLNOxX0RfndiYSt1Le9azze&si=iHn7rWgUDeXbOrd8)

