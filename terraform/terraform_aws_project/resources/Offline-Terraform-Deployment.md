# Deploy Terraform in Offline Machine

Running Terraform on an offline machine requires downloading all necessary Terraform binaries and provider plugins beforehand and ensuring that Terraform does not attempt to reach external resources during execution. Here’s how you can do it:


---

1. Prepare Terraform & Providers on an Online Machine

Before transferring Terraform to the offline machine, do the following steps on a machine with internet access:

Step 1: Download Terraform Binary

Download the correct Terraform binary for your OS from Terraform Releases.

Example (Linux):

wget https://releases.hashicorp.com/terraform/1.6.0/terraform_1.6.0_linux_amd64.zip
unzip terraform_1.6.0_linux_amd64.zip
mv terraform /usr/local/bin/

For Windows, download the .zip file and extract it.

Step 2: Download Terraform Provider Plugins

To prevent Terraform from downloading providers online, manually download the required provider plugins.

Example for AWS provider:

terraform init

After initialization, the provider plugins are stored in:

~/.terraform.d/plugin-cache/

or

.terraform/providers/

Copy these directories to use them on the offline machine.

Step 3: Configure Terraform Plugin Cache

Edit ~/.terraformrc (for Linux/Mac) or %APPDATA%\terraform.rc (Windows) to specify a local plugin cache:

plugin_cache_dir = "/path/to/local/plugin-cache"

Then, run:

terraform providers mirror /path/to/local/plugin-cache

Copy the /path/to/local/plugin-cache folder to the offline machine.


---

2. Transfer to the Offline Machine

Copy the following to the offline machine:

The Terraform binary (terraform executable)

The Terraform working directory containing .terraform/

The provider plugin cache directory (plugin-cache/)



---

3. Run Terraform in Offline Mode

On the offline machine, configure Terraform to use the local plugins:

Step 1: Set Environment Variables

export TF_PLUGIN_CACHE_DIR="/path/to/plugin-cache"
export TF_REGISTRY_MIRRORS="file:///path/to/plugin-cache"

Step 2: Initialize Terraform Without Internet

terraform init -plugin-dir=/path/to/plugin-cache

This prevents Terraform from trying to download plugins from the internet.

Step 3: Apply Terraform Configuration

Now, you can run:

terraform plan
terraform apply

Terraform will use the locally cached plugins and execute without needing internet access.


---

Summary

1. Download Terraform & required plugins on an online machine.


2. Mirror the provider plugins and copy them to an offline machine.


3. Use the local plugin cache on the offline machine.


4. Run terraform init with -plugin-dir to ensure Terraform doesn't try to fetch resources online.



This method ensures Terraform can run completely offline while still using the correct provider versions.

