### Detailed Notes on Terraform Workspaces

---

### Introduction to Terraform Workspaces

Terraform workspaces provide a mechanism to manage multiple environments (e.g., dev, staging, production) using the same Terraform configuration. This is useful for avoiding the need to duplicate configurations for different environments, allowing for better maintainability and consistency.

#### Key Benefits:
1. **Single Configuration**: Use a single Terraform project for multiple environments.
2. **Environment Isolation**: Each workspace maintains its own state file, preventing conflicts between environments.
3. **Consistency**: Ensures consistent infrastructure definitions across environments.

### Understanding Terraform Workspaces

#### Problem Statement:
Teams often need to create similar infrastructure in different environments (e.g., dev, staging, production). Without workspaces, this would involve duplicating the Terraform configurations and managing separate state files manually, leading to potential errors and inconsistencies.

#### Example Scenario:
A team wants to create an EC2 instance and an S3 bucket in AWS. Instead of duplicating the Terraform project for each environment, they can use workspaces to manage different environments within the same project.

### Creating and Managing Terraform Workspaces

#### Basic Commands:

- **Create a Workspace**:
  ```bash
  terraform workspace new <workspace_name>
  ```

- **List Workspaces**:
  ```bash
  terraform workspace list
  ```

  output:
  default
* dev
  staging
  production
The * indicates the current active workspace.

- **Switch Workspaces**:
  ```bash
  terraform workspace select <workspace_name>
  ```

- **Show Current Workspace**:
  ```bash
  terraform workspace show
  ```

- **Delete Workspace**:
  ```bash
  terraform workspace delete <workspace_name>
  ```
This command deletes the workspace. Note that you cannot delete the workspace you are currently using; you must switch to a different workspace first. To delete the Infra also on that workspace first use Terraform destroy then delete the workspace.

#### Example Commands:
- Creating a new workspace for staging:
  ```bash
  terraform workspace new staging
  ```

- Switching to the production workspace:
  ```bash
  terraform workspace select production
  ```

### Practical Demonstration: Setting Up Workspaces

#### Step-by-Step Setup:

1. **Initialize Terraform**:
   ```bash
   terraform init
   ```

2. **Create and Switch Workspaces**:
   ```bash
   terraform workspace new dev
   terraform workspace new staging
   terraform workspace new production
   ```

3. **Define Main Configuration** (`main.tf`):
   ```hcl
   provider "aws" {
     region = var.region
   }

   module "ec2_instance" {
     source       = "./modules/ec2_instance"
     ami          = var.ami
     instance_type = var.instance_type
   }
   ```

4. **Variables Definition** (`variables.tf`):
   ```hcl
   variable "region" {
     description = "AWS region"
     type        = string
     default     = "us-east-1"
   }

   variable "ami" {
     description = "AMI ID"
     type        = string
   }

   variable "instance_type" {
     description = "Instance type"
     type        = string
   }
   ```

5. **Environment-Specific Variables** (`terraform.tfvars` for each workspace):
   - **Dev** (`dev.tfvars`):
     ```hcl
     ami           = "ami-0c55b159cbfafe1f0"
     instance_type = "t2.micro"
     ```

   - **Staging** (`staging.tfvars`):
     ```hcl
     ami           = "ami-0c55b159cbfafe1f0"
     instance_type = "t2.medium"
     ```

   - **Production** (`production.tfvars`):
     ```hcl
     ami           = "ami-0c55b159cbfafe1f0"
     instance_type = "t2.large"
     ```

6. **Applying Configuration**:
   - **For Dev**:
     ```bash
     terraform workspace select dev
     terraform apply -var-file="dev.tfvars"
     ```

   - **For Staging**:
     ```bash
     terraform workspace select staging
     terraform apply -var-file="staging.tfvars"
     ```

   - **For Production**:
     ```bash
     terraform workspace select production
     terraform apply -var-file="production.tfvars"
     ```

### Conclusion

Terraform workspaces streamline the process of managing multiple environments with a single Terraform configuration. By maintaining separate state files for each workspace, Terraform ensures that changes in one environment do not affect others, thus promoting consistency and reducing errors.

---

These notes cover the essential aspects of Terraform workspaces and provide practical commands and examples to facilitate understanding and implementation.