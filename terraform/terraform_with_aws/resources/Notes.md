# Useful Info and Questions


## Useful Commands
#### Workspace
``` sh
terradorm workspace                    # Command related to workspace
terraform workspace new <workspace>    # Create a new workspace
terraform workspace select <workspace> # Switch between environments
terraform workspace list               # List all available workspaces
terraform workspace delete <workspace> # Delete a specific workspace
terraform workspace show               # Display the current workspace
terraform workspace default            # Switch to the default workspace
```


#### Terraform Commands
```sh
terraform init     # Initialize a Terraform working directory
terraform validate # Validate the Terraform configuration files
terraform plan     # Preview changes before applying
terraform apply    # Apply the changes required to reach the desired state
terraform destroy  # Destroy the Terraform-managed infrastructure
terraform fmt      # Format Terraform configuration files
terraform output   # Read an output variable from a state file
terraform state    # Advanced state management commands
terraform graph    # Generate a visual representation of the configuration
terraform refresh  # Update the state file with real-world resources
```

---

## Notes
- Environment variables should have the prefix TF_VAR_ to be automatically picked up by Terraform's variable.tf: `export TL_VAR_foo=hello`
- The etag attribute is used in the aws_s3_object resource to ensure files are uploaded only if they change: `etag = filemd5("./resources/dummy-file.txt")`

---

## Questions
### **1. What is Terraform?**
**Q:** What is Terraform?  
**A:** Terraform is an open-source infrastructure as code (IaC) tool that allows you to define, provision, and manage infrastructure using configuration files. It supports cloud providers like AWS, Azure, Google Cloud, and more. Terraform creates, updates, and manages infrastructure resources in a safe, repeatable manner.

---

### **2. What is a Provider in Terraform?**
**Q:** What is a provider in Terraform?  
**A:** A provider is a plugin in Terraform that allows it to interact with various cloud platforms and services (e.g., AWS, Azure, Google Cloud). Each provider is responsible for understanding API interactions for a given service.

Example:
```hcl
provider "aws" {
  region = "us-west-2"
}
```

---

### **3. What are Terraform Resources?**
**Q:** What are Terraform resources?  
**A:** Resources are the most important element of the Terraform configuration. They represent the infrastructure components you want to create or manage (e.g., EC2 instances, S3 buckets, VPCs).

Example:
```hcl
resource "aws_instance" "example" {
  ami           = "ami-0c55b159cbfafe1f0"
  instance_type = "t2.micro"
}
```

---

### **4. What is the purpose of `terraform init`?**
**Q:** What does the `terraform init` command do?  
**A:** `terraform init` initializes a Terraform working directory. It downloads the provider plugins required for the configuration, initializes the backend (for state storage), and prepares the directory for further Terraform commands.

---

### **5. What is a Terraform State?**
**Q:** What is Terraform state?  
**A:** Terraform state is the mechanism by which Terraform tracks infrastructure it manages. State is used to map your configuration to real-world resources. Terraform saves this state in a file called `terraform.tfstate` by default.

---

### **6. What is `terraform apply`?**
**Q:** What does the `terraform apply` command do?  
**A:** `terraform apply` is used to apply changes to your infrastructure based on your configuration files. It calculates the differences (a "plan") and applies the changes to reach the desired state. You are usually prompted to confirm the changes before they are applied.

---

### **7. What is `terraform plan`?**
**Q:** What does the `terraform plan` command do?  
**A:** `terraform plan` shows what changes will be made to your infrastructure when you run `terraform apply`. It helps you review the changes Terraform will make before actually applying them.

---

### **8. What is a Terraform Module?**
**Q:** What is a Terraform module?  
**A:** A Terraform module is a container for multiple resources that are used together. Modules help organize and reuse code. You can use modules for better organization and encapsulation.

Example:
```hcl
module "vpc" {
  source = "./modules/vpc"
  cidr_block = "10.0.0.0/16"
}
```

---

### **9. How to use Variables in Terraform?**
**Q:** How do you define and use variables in Terraform?  
**A:** Variables in Terraform are defined using the `variable` block. You can use them in your resource definitions, and assign values through `terraform.tfvars` or environment variables.

Example:
```hcl
variable "instance_type" {
  default = "t2.micro"
}

resource "aws_instance" "example" {
  instance_type = var.instance_type
}
```

---

### **10. What is a Terraform Output?**
**Q:** What is an output in Terraform?  
**A:** Outputs in Terraform allow you to display values after an apply operation. This can be useful for getting resource IDs or other details that you may need after the resources are created.

Example:
```hcl
output "instance_public_ip" {
  value = aws_instance.example.public_ip
}
```

---

### **11. What is the `depends_on` argument?**
**Q:** What does the `depends_on` argument do?  
**A:** The `depends_on` argument explicitly specifies resource dependencies, ensuring that one resource is created or modified before another. This is useful when implicit dependencies aren’t sufficient.

Example:
```hcl
resource "aws_security_group" "example" {
  # resource definition
}

resource "aws_instance" "example" {
  depends_on = [aws_security_group.example]
}
```

---

### **12. How do I handle credentials in Terraform?**
**Q:** How can I set AWS credentials for Terraform?  
**A:** You can set AWS credentials using the following methods:
1. **Environment Variables**:
   ```bash
   export AWS_ACCESS_KEY_ID="your-access-key"
   export AWS_SECRET_ACCESS_KEY="your-secret-key"
   ```
2. **AWS CLI Configuration**:
   Run `aws configure` to store credentials in `~/.aws/credentials`.
3. **Directly in Provider (Not Recommended)**:
   ```hcl
   provider "aws" {
     access_key = "your-access-key"
     secret_key = "your-secret-key"
     region     = "us-west-2"
   }
   ```

---

### **13. How do I handle remote backends in Terraform?**
**Q:** What is a remote backend in Terraform?  
**A:** A remote backend allows Terraform's state file to be stored remotely, providing better collaboration and state sharing. The state can be stored in an S3 bucket, Azure Storage Account, or other services.

Example with S3 Backend:
```hcl
terraform {
  backend "s3" {
    bucket         = "your-terraform-state-bucket"
    key            = "terraform.tfstate"
    region         = "us-east-1"
    encrypt        = true
    dynamodb_table = "terraform-lock-table"
  }
}
```

---

### **14. What is a `terraform workspace`?**
**Q:** What is a workspace in Terraform?  
**A:** A workspace is an isolated environment for Terraform configurations. It allows you to have different state files for the same configuration, useful for managing different environments (e.g., `dev`, `staging`, `prod`).

- Create a new workspace:  
  ```bash
  terraform workspace new dev
  ```

- List all workspaces:  
  ```bash
  terraform workspace list
  ```

- Switch workspaces:  
  ```bash
  terraform workspace select dev
  ```

---

### **15. How to handle version control in Terraform?**
**Q:** How do I manage Terraform configurations in version control?  
**A:** You should **never** commit `terraform.tfstate` or `terraform.tfstate.backup` files to version control. Use a `.gitignore` file to exclude them:
```plaintext
*.tfstate
*.tfstate.backup
```

---

### **16. How to use `terraform import`?**
**Q:** What is `terraform import`?  
**A:** `terraform import` allows you to import existing infrastructure into your Terraform state, without modifying the infrastructure. This helps bring manually created resources under Terraform management.

Example:
```bash
terraform import aws_instance.example i-0abcd1234efgh5678
```

---

### **17. How to define conditional logic in Terraform?**
**Q:** How can I use conditions in Terraform?  
**A:** You can use `count`, `for_each`, or the ternary operator for conditional logic in Terraform.

Example using `count`:
```hcl
resource "aws_instance" "example" {
  count         = var.create_instance ? 1 : 0
  ami           = "ami-0c55b159cbfafe1f0"
  instance_type = "t2.micro"
}
```

---

### **18. How to apply a plan without confirmation?**
**Q:** How do I apply a Terraform plan without confirmation?  
**A:** You can use the `-auto-approve` flag to skip confirmation prompts:
```bash
terraform apply -auto-approve
```

---

### **19. How to handle multiple environments with Terraform?**
**Q:** How do I manage multiple environments (like dev, staging, prod) with Terraform?  
**A:** You can use:
1. **Workspaces**: Use different workspaces for each environment.
2. **Module-based configurations**: Use modules and `-var-file` to customize configurations for different environments.
3. **Backend configurations**: Use different state backends for each environment.

---

### **20. What are Terraform provisioners?**
**Q:** What are Terraform provisioners?  
**A:** Provisioners in Terraform are used to execute scripts or actions on a resource after it’s created. Commonly used provisioners include `remote-exec` and `local-exec`.

Example:
```hcl
resource "aws_instance" "example" {
  ami           = "ami-0c55b159cbfafe1f0"
  instance_type = "t2.micro"

  provisioner "remote-exec" {
    inline = [
      "sudo yum install -y httpd",
      "sudo service httpd start"
    ]
  }
}
```

---

### **21. What is the `terraform destroy` command?**
**Q:** What does the `terraform destroy` command do?  
**A:** `terraform destroy` is used to delete all the infrastructure managed by your Terraform configuration. It will remove all resources defined in your configuration files.
