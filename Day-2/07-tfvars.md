# Terraform tfvars

In Terraform, `.tfvars` files (typically with a `.tfvars` extension) are used to set specific values for input variables defined in your Terraform configuration. 

They allow you to separate configuration values from your Terraform code, making it easier to manage different configurations for different environments (e.g., development, staging, production) or to store sensitive information without exposing it in your code.

Here's the purpose of `.tfvars` files:

1. **Separation of Configuration from Code**: Input variables in Terraform are meant to be configurable so that you can use the same code with different sets of values. Instead of hardcoding these values directly into your `.tf` files, you use `.tfvars` files to keep the configuration separate. This makes it easier to maintain and manage configurations for different environments.

2. **Sensitive Information**: `.tfvars` files are a common place to store sensitive information like API keys, access credentials, or secrets. These sensitive values can be kept outside the version control system, enhancing security and preventing accidental exposure of secrets in your codebase.

3. **Reusability**: By keeping configuration values in separate `.tfvars` files, you can reuse the same Terraform code with different sets of variables. This is useful for creating infrastructure for different projects or environments using a single set of Terraform modules.

4. **Collaboration**: When working in a team, each team member can have their own `.tfvars` file to set values specific to their environment or workflow. This avoids conflicts in the codebase when multiple people are working on the same Terraform project.


### Directory Structure

```
terraform/
├── main.tf
├── variables.tf
├── outputs.tf
├── dev.tfvars
├── staging.tfvars
└── prod.tfvars
```
Here's how you typically use `.tfvars` files

1. Define your input variables in your Terraform code (e.g., in a `variables.tf` file).

2. Create one or more `.tfvars` files, each containing specific values for those input variables.

3. When running Terraform commands (e.g., terraform apply, terraform plan), you can specify which .tfvars file(s) to use with the -var-file option:

```
terraform apply -var-file=dev.tfvars
```

### Example of different files of directory structure

#### `variables.tf`

This file defines the input variables for your Terraform configuration.

```hcl
# variables.tf

variable "region" {
  description = "The AWS region to deploy resources into."
  type        = string
}

variable "instance_type" {
  description = "The type of instance to use."
  type        = string
}

variable "environment" {
  description = "The environment for which to deploy resources."
  type        = string
}

variable "tags" {
  description = "Tags to apply to the resources."
  type        = map(string)
  default     = {}
}
```

#### `dev.tfvars`

This file contains values specific to the `dev` environment.

```hcl
# dev.tfvars

region         = "us-west-1"
instance_type  = "t2.micro"
environment    = "dev"
tags = {
  Name        = "dev-instance"
  Environment = "development"
}
```

#### `staging.tfvars`

This file contains values specific to the `staging` environment.

```hcl
# staging.tfvars

region         = "us-west-2"
instance_type  = "t2.medium"
environment    = "staging"
tags = {
  Name        = "staging-instance"
  Environment = "staging"
}
```

#### `prod.tfvars`

This file contains values specific to the `prod` environment.

```hcl
# prod.tfvars

region         = "us-east-1"
instance_type  = "t2.large"
environment    = "prod"
tags = {
  Name        = "prod-instance"
  Environment = "production"
}
```

### Usage

When applying or planning your Terraform configuration, you can specify the environment-specific `.tfvars` file like this:

```sh
terraform plan -var-file="dev.tfvars"
terraform apply -var-file="prod.tfvars"
```
## Summary
This setup allows you to maintain environment-specific configurations easily and keep your main Terraform configuration clean and reusable. Adjust the variable names and values according to your specific needs and infrastructure requirements.


