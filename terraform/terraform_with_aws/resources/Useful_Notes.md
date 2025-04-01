# Useful Helpers and Notes


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
- 