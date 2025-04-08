# AWS Resource Automation using Bash Scripts

This project contains a set of Bash scripts to automate the creation and deletion of AWS resources using the AWS CLI. It's designed as a hands-on learning tool for gaining experience with cloud infrastructure management through scripting.

---

### Directory Structure

```
.
├── create_load-balancer.sh       # Create an Application Load Balancer (ALB)
├── create_security-group.sh      # Create security groups with rules
├── create_vpc.sh                 # Create a VPC with subnets, route tables, etc.
├── delete_security-group.sh      # Delete security groups
├── delete_vpc.sh                 # Delete the VPC and its dependencies
├── create_ec2.sh                 # Launch and manage EC2 instances
├── create_iam-users.sh           # Create IAM users and assign policies
└── create_s3-bucket.sh           # Create and manage S3 buckets
```

---

### Prerequisites

Make sure you have the following before using the scripts:

- **AWS CLI v2** installed and configured: `aws configure`
- IAM user with required permissions (EC2, VPC, S3, IAM, ELB, etc.)
- Bash shell environment (Linux/macOS/WSL)
- (Optional) **jq** for better JSON output parsing: `sudo apt install jq`

---

### How to Use

Each script is standalone and can be executed directly: `bash <script-name>.sh`

> Tip: Use `chmod +x <script-name>.sh` to make scripts executable if needed.

---

### Script Descriptions

- [create_vpc.sh](create_vpc.sh)
    - Creates a new VPC along with associated components

- [create_security-group.sh](create_security-group.sh)
    - Creates one or more security groups.

- [delete_security-group.sh](delete_security-group.sh)
    - Deletes the security groups created earlier.

- [delete_vpc.sh](delete_vpc.sh)
    - Cleans up the entire VPC stack

- [create_ec2.sh)](create_ec2.sh)
    - Launches EC2 instances

- [create_load-balancer.sh](create_load-balancer.sh)
    - Sets up an Application Load Balancer

- [create_iam-users.sh](create_iam-users.sh)
    - Creates IAM users

- [create_s3-bucket.sh](create_s3-bucket.sh)
    - Handles S3 bucket operations

---

### Suggested Workflow

```bash
bash create_vpc.sh
bash create_security-group.sh
bash ec2.sh
bash create_load-balancer.sh
```

After testing:

```bash
bash delete_security-group.sh
bash delete_vpc.sh
```

---

### Best Practices

- Always test in a **non-production** environment
- Use **tags** for resource identification and cost tracking
- Consider adding error handling, logging, and config files
- Store AWS credentials securely (don’t hardcode in scripts)
- Clean up unused resources to avoid charges

---

### Notes
- Boto3 for Python Script for AWS Automation
- Get security credentials (Login to AWS -> Profile -> Security Credentials -> Access Keys -> Create Key)

---

### References
- **AWS Course Playlist:** [AWS Projects - YouTube](https://youtube.com/playlist?list=PLdpzxOOAlwvLNOxX0RfndiYSt1Le9azze&si=iHn7rWgUDeXbOrd8)
- **AWS Exercise:** [AWS Exercise](https://docs.aws.amazon.com/vpc/latest/userguide/vpc-example-private-subnets-nat.html)
- **AWS Exercise Practical:** [AWS Exercise Practical](https://www.youtube.com/watch?v=FZPTL_kNvXc&t=1799s&ab_channel=Abhishek.Veeramalla)
- **Boto3 Documentation:** [Boto3 Doc](https://boto3.amazonaws.com/v1/documentation/api/latest/index.html)
- https://docs.aws.amazon.com/cli/latest/userguide/cli-chap-getting-started.html
- https://docs.aws.amazon.com/cli/latest/userguide/cli-chap-welcome.html
---

### Major Topics
- IAM (Identity and Access Management): Users, Groups, Policies, Roles
- EC2 (Elastic Compute Cloud)
- VPC (Virtual Private Cloud)
- Security Groups
- NACL (Network Access Control Lists)
- Route 53
- S3 (Simple Storage Service) 
- AWS CLI
- AWS CFT (AWS CloudFormation) (Infrastructure as Code) --- SKIP will use Terraform
    - Used JSON/Yaml to define and provision AWS resources
- AWS CICD: AWS CodeCommit, AWS Code Pipeline, AWS CodeBuild, AWS CodeDeploy
    - Codecommit is like GIT
    - Code Pipeline is like Jenkins
    - CodeBuild is like Maven build
    - CodeDeploy is like Argo Deploy
- AWS Load Balancer
- Lamda (Serverless Architecture)
- Secret Management
- Cost Optimization

---

### Author
**Prashant Jeet Singh** – DevOps Learner  
_This project was built as part of a personal hands-on journey with AWS and Bash scripting. This project is created for Terraform practice and learning purposes._
