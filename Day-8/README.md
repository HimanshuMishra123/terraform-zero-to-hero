# MIGRATION TO TERRAFORM & DRIFT DETECTION

#### Overview
This guide focuses on two crucial aspects of using Terraform: migrating existing infrastructure to Terraform and detecting drifts in configurations. 

### 1. **Migration to Terraform**

#### Scenario:
You have infrastructure managed by a cloud provider (e.g., AWS) using tools like CloudFormation, and you want to migrate this setup to Terraform. 

#### Steps:

1. **Prepare the Environment**:
   - Use CodeSpaces or your preferred environment.
   - Create a directory structure for organization:
     ```bash
     mkdir -p prjoect/import-resources
     cd prjoect/import-resources
     ```

2. **Create Initial Terraform Configuration**:
   - Write a `main.tf` file:
     ```hcl
     provider "aws" {
       region = "us-east-1"
     }

     import {
        id = "i-0573763ef5312afd6"

        to = aws_instance.example
     }
     ```

- id is instance id.
- to is to define resource name where the resource configuration will be imported
- import from 'id' to 'to' 

3. **To generate resource configuration file**:
     
   - Run the following commands first to initialize terraform and then generate a config file(give any name like...generated_resource_config.tf):

     ```bash
     terraform init
     terraform plan -generate-config-out=generated_resource_config.tf
     ```
   - This generates a new configuration file (`generated_resource_config.tf`) that includes all the details of the existing EC2 instance. <br/>

note: ignore error : conflicting configuration arguments(which is related to Ipv6)

4. **Modify and Clean Up Configuration**:
   - Copy the configuration content from generated_resource_config file into your `main.tf`:
     ```hcl

     provider "aws" {
       region = "us-east-1"
     }


     resource "aws_instance" "example" {
       # Paste Configuration details copied.
     }
     ```
     
- Delete the generated configuration file(generated_resource_config.tf) and unnecessary blocks in main.tf as terraform has imported required as well as optional fields of the instance.

5. **Import Existing Resources**:
   - Use the `terraform import` command to import/generate the terraform state file:
     ```bash
     terraform import aws_instance.example <instance_id>
     ```
   - Validate with `terraform plan` to ensure no changes are required:
     ```bash
     terraform plan
     ```

- If you do terraform plan without doing terraform import it will show '1 to add' as ther is no state file present having configuration of the resource.

#### Key Points:
- Terraform import helps to bring existing resources under Terraform management.
- The import process involves creating a resource block and running `terraform import`.


### 2. **Drift Detection**

#### Scenario:
Detecting changes made outside of Terraform, also known as drift, to ensure infrastructure state remains consistent.

#### Strategies:

1. **Terraform Refresh**:
   - The `terraform refresh` command updates the state file to match the real-world resources:
     ```bash
     terraform refresh
     ```
   - This command can be scheduled as a cron job to periodically check for drifts.

2. **Implementing Audit Logs and Automation**:
   - **Strict IAM Policies**: Restrict manual changes by enforcing strict IAM policies.
   - **Audit Logs and Lambda Functions**:
     - Configure CloudWatch or another logging tool to monitor changes.
     - Use a Lambda function to check if changes are made by non-Terraform IAM roles.
     - Example workflow:
       1. Detect manual changes via audit logs.
       2. Lambda function cross-references changes with Terraform-managed resources.
       3. Send notifications if manual changes are detected.

#### Example for Drift Detection using Lambda and CloudWatch:
- **Lambda Function**:
  ```python
  import boto3

  def lambda_handler(event, context):
      # Logic to check for manual changes and send notifications
  ```

- **CloudWatch Rule**:
  - Set up a rule to trigger the Lambda function based on specific events/log entries.

#### Key Points:
- Drift detection is crucial to maintain consistency.
- Terraform refresh is a native command but may be deprecated.
- Using IAM policies and automated audits provides a robust solution.

---

### Additional Tips:
- **Example Terraform Commands**:
  - Initialize Terraform:
    ```bash
    terraform init
    ```
  - Generate configuration:
    ```bash
    terraform plan -generate-config-out=config.tf
    ```
  - Apply configuration:
    ```bash
    terraform apply
    ```
  - Import resource:
    ```bash
    terraform import aws_instance.example <instance_id>
    ```
  - Refresh state:
    ```bash
    terraform refresh
    ```

### Conclusion:
Understanding and implementing Terraform migration and drift detection ensures a robust and manageable infrastructure. These strategies help in seamlessly integrating existing resources into Terraform and maintaining consistent configurations.