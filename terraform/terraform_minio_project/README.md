 # Terraform with MinIO
 
 ### Table of Contents
 1. [Overview](#overview)
 2. [Folder Structure](#folder-structure)
 3. [Prerequisites](#prerequisites)
 4. [Modules Overview](#modules-overview)
    - [MinIO](#minio-module)
 6. [Running Terraform](#running-terraform)
 7. [Conclusion](#conclusion)
 8. [Author](#author)
 9. [References](#references)

 ---

### Overview
This repository contains Terraform configurations to provision and manage MinIO resources using Infrastructure as Code (IaC). This also elloborates usage of remote backends to allow Terraform's state file to be stored remotely

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
│── provifers.tf
│── README.md
```

---

### Prerequisites
1. **Create an Access Key for Terraform**
    ```
    mc alias set <ALIAS> <URL> <ACCESS_KEY> <SECRET_KEY> # Set MinIO Alias
    mc admin user add <ALIAS> <USERNAME> <PASSWORD> # Create new user, password
    mc admin policy attach local readwrite --user=<USERNAME> # Assign Read/Write Policy
    ```
2. Provide minio_url in [terraform.tfvars](terraform.tfvars)

---

### Modules Overview
### **MinIO Module**
1. **Create Bucket:** Provision a new bucket to store and manage objects securely.  

2. **Enable Versioning:** Activate versioning on the bucket to retain previous versions of objects, providing protection against accidental deletions or overwrites.   

3. **Create Folder in Bucket:** Organize content by creating structured folders within the bucket for efficient data management.  

4. **Upload File:** Upload files to the specified folder in the bucket for storage and retrieval.  

5. **Refresh Terraform State:** Update the Terraform state to reflect the latest changes after uploading files, ensuring consistency between the infrastructure and state file.  

6. **List Objects in a Specific Folder:** Retrieve a list of all objects within a particular folder inside the bucket using Terraform's data source feature.  

7. **List All Objects in the Bucket:** Fetch details of all objects stored in the entire bucket for inventory or auditing purposes.  

8. **Download a Specific File from the Bucket:** Retrieve a particular file from the bucket for local use or further processing.  

---

### Running Terraform
```sh
export TF_VAR_access_key=<ACCESS_KEY>
export TF_VAR_secret_key=<SECRET_KEY>
terraform init
terraform plan    # Preview changes
terraform apply   # Apply changes
terraform destroy # Destroy resources
```

---

### Conclusion
This repository provides a structured approach to create bucket on MinIO using Terraform.

---

### Author
This project is created for Terraform practice and learning purposes.

---

### References
- **MinIO Documentation:** [MinIO Documentation](https://registry.terraform.io/providers/aminueza/minio/latest/docs)