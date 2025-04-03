# Deploy Terraform in Offline Machine

Running Terraform on an offline machine requires downloading all necessary Terraform binaries and provider plugins beforehand and ensuring that Terraform does not attempt to reach external resources during execution. Here’s how you can do it:

---

### Prepare Terraform & Providers on an Online Machine

Before transferring Terraform to the offline machine, do the following steps on a machine with internet access:

#### Step 1: Download Terraform Binary
Download the correct Terraform binary for your OS from Terraform Releases.

#### Step 2: Download Terraform Provider Plugins
To prevent Terraform from downloading providers online, manually download the required provider plugins. Example for AWS provider: `terraform init`
After initialization, the provider plugins are stored in: `~/.terraform.d/plugin-cache/` or `.terraform/providers/`
Copy these directories to use them on the offline machine.

#### Step 3: Configure Terraform Plugin Cache
Run: `terraform providers mirror /path/to/local/plugin-cache`
Copy the `/path/to/local/plugin-cache` folder to the offline machine.

#### Step 4: Transfer to the Offline Machine
- Copy the following to the offline machine:
  - The Terraform binary (terraform executable)
  - The Terraform working directory containing .terraform/
  - The provider plugin cache directory (plugin-cache/)

#### Step 5: Run Terraform in Offline Mode
- Initialize Terraform Without Internet: `terraform init -plugin-dir=/path/to/plugin-cache`
- This prevents Terraform from trying to download plugins from the internet.
- Apply Terraform Configuration

    ```
    terraform plan
    terraform apply
    ```

- Terraform will use the locally cached plugins and execute without needing internet access.

---

Summary

1. Download Terraform & required plugins on an online machine.
2. Mirror the provider plugins and copy them to an offline machine.
3. Use the local plugin cache on the offline machine.
4. Run terraform init with -plugin-dir to ensure Terraform doesn't try to fetch resources online.

This method ensures Terraform can run completely offline while still using the correct provider versions.

