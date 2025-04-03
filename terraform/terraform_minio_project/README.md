# Terraform with MinIO

### Table of Contents
1. [Overview](#overview)
2. [Folder Structure](#folder-structure)
3. [Prerequisites](#prerequisites)
4. [Modules Overview](#modules-overview)
    - [MinIO Module](#minio-module)
5. [Running Terraform](#running-terraform)
6. [Features](#features)
7. [Conclusion](#conclusion)
8. [Author](#author)
9. [References](#references)

---

### Overview
This repository contains Terraform configurations to provision and manage MinIO resources using Infrastructure as Code (IaC). MinIO is an S3-compatible object storage solution that can be used for storing and managing unstructured data.

---

### Folder Structure
```
terraform_minio_project/
│── modules/
│   ├── minio/
│   │   ├── main.tf
│   │   ├── variables.tf
│   │   ├── outputs.tf
│── resources/
│   ├── dummy-file.txt
│   ├── docker-compose-minio.yml
│── main.tf
│── variables.tf
│── outputs.tf
│── terraform.tfvars
│── providers.tf
│── README.md
```

---

### Prerequisites
1. **Set Up MinIO Access Key and Secret Key**
    ```sh
    mc alias set <ALIAS> <URL> <ACCESS_KEY> <SECRET_KEY> # Set MinIO Alias
    mc admin user add <ALIAS> <USERNAME> <PASSWORD>      # Create a new user with a password
    mc admin policy attach local readwrite --user=<USERNAME> # Assign Read/Write Policy
    ```

2. **Provide `minio_url` in `terraform.tfvars`**
    - Example:
      ```hcl
      minio_url = "http://localhost:9000"
      ```

3. **Install Terraform**
    - Ensure Terraform is installed on your system. You can download it from [Terraform Downloads](https://www.terraform.io/downloads).

4. **Run MinIO Locally (Optional)**
    - Use the provided `docker-compose-minio.yml` file to run MinIO locally:
      ```sh
      docker-compose -f resources/docker-compose-minio.yml up -d
      ```

---

### Modules Overview

#### **MinIO Module**
The MinIO module provides the following functionalities:

1. **Create Bucket**: Provision a new bucket to store and manage objects securely.
2. **Enable Versioning**: Activate versioning on the bucket to retain previous versions of objects, providing protection against accidental deletions or overwrites.
3. **Create Folder in Bucket**: Organize content by creating structured folders within the bucket for efficient data management.
4. **Upload File**: Upload files to the specified folder in the bucket for storage and retrieval.
5. **Refresh Terraform State**: Update the Terraform state to reflect the latest changes after uploading files, ensuring consistency between the infrastructure and state file.
6. **List Objects in a Specific Folder**: Retrieve a list of all objects within a particular folder inside the bucket using Terraform's data source feature.
7. **List All Objects in the Bucket**: Fetch details of all objects stored in the entire bucket for inventory or auditing purposes.
8. **Download a Specific File from the Bucket**: Retrieve a particular file from the bucket for local use or further processing.

---

### Running Terraform
Follow these steps to run Terraform and manage MinIO resources:

1. **Export Environment Variables**
    ```sh
    export TF_VAR_access_key=<ACCESS_KEY>
    export TF_VAR_secret_key=<SECRET_KEY>
    ```

2. **Initialize Terraform**
    ```sh
    terraform init
    ```

3. **Plan Changes**
    ```sh
    terraform plan
    ```

4. **Apply Changes**
    ```sh
    terraform apply
    ```

5. **Destroy Resources**
    ```sh
    terraform destroy
    ```

---

### Features
- **Infrastructure as Code (IaC)**: Manage MinIO resources declaratively using Terraform.
- **S3-Compatible**: Leverage MinIO's compatibility with the S3 API for seamless integration.
- **Versioning Support**: Enable versioning to protect against accidental data loss.
- **Custom Folder Management**: Organize data efficiently with folder creation and management.
- **Data Retrieval**: List and download objects from MinIO buckets.

---

### Conclusion
This repository provides a structured approach to managing MinIO resources using Terraform. It simplifies the process of provisioning, organizing, and managing object storage with MinIO.

---

### Author
This project is created for Terraform practice and learning purposes.

---

### References
- **MinIO Documentation**: [MinIO Provider Documentation](https://registry.terraform.io/providers/aminueza/minio/latest/docs)
- **Terraform Documentation**: [Terraform Official Documentation](https://www.terraform.io/docs)
- **Docker Compose**: [Docker Compose Documentation](https://docs.docker.com/compose/)