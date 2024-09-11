# Conditional Expressions

Conditional expressions in Terraform are used to define conditional logic within your configurations. They allow you to make decisions or set values based on conditions. Conditional expressions are typically used to control whether resources are created or configured based on the evaluation of a condition.

The syntax for a conditional expression in Terraform is:

```hcl
condition ? true_val : false_val
```

- `condition` is an expression that evaluates to either `true` or `false`.
- `true_val` is the value that is returned if the condition is `true` means condition fulfilled.
- `false_val` is the value that is returned if the condition is `false` means conditioned not matched.

Here are some common use cases and examples of how to use conditional expressions in Terraform:

## Conditional Resource Creation Example

```hcl
resource "aws_instance" "example" {
  count = var.create_instance ? 1 : 0

  ami           = "ami-XXXXXXXXXXXXXXXXX"
  instance_type = "t2.micro"
}
```

In this example, the `count` attribute of the `aws_instance` resource uses a conditional expression. If the `create_instance` variable is `true`, it creates one EC2 instance. If `create_instance` is `false`, it creates zero instances, effectively skipping resource creation.

# Conditional Variable Assignment Example

```hcl
variable "environment" {
  description = "Environment type"
  type        = string
  default     = "development"
}

variable "production_subnet_cidr" {
  description = "CIDR block for production subnet"
  type        = string
  default     = "10.0.1.0/24"
}

variable "development_subnet_cidr" {
  description = "CIDR block for development subnet"
  type        = string
  default     = "10.0.2.0/24"
}

resource "aws_security_group" "example" {
  name        = "example-sg"
  description = "Example security group"

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = var.environment == "production" ? [var.production_subnet_cidr] : [var.development_subnet_cidr]
  }
}

```

In this example, the `locals` block uses a conditional expression to assign a value to the `subnet_cidr` local variable based on the value of the `environment` variable. If `environment` is set to `"production"`, it uses the `production_subnet_cidr` variable; otherwise, it uses the `development_subnet_cidr` variable.
**By using this concept you don't have to write different codes for different environments**


### Conditional Resource Configuration 

```hcl
resource "aws_security_group" "example" {
  name        = "example-sg"
  description = "Example security group"
  vpc_id      = var.vpc_id  # Make sure to specify the VPC ID if not using the default VPC

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = var.enable_ssh ? ["0.0.0.0/0"] : []
    # You can also use `security_groups` or `self` if necessary
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "example-sg"
  }
}
```

### Explanation and Improvements

1. **Added `vpc_id`**:
   - Ensure you specify the VPC ID where the security group should be created. This is necessary if you're not using the default VPC or if you want to explicitly define the VPC.

2. **Egress Rules**:
   - Added a default egress rule that allows all outbound traffic. This is often needed unless you have specific outbound rules. Adjust or remove this based on your security requirements.

3. **Tags**:
   - Added tags to the security group. Tags help in identifying and managing resources.

4. **Comment on `cidr_blocks`**:
   - The `cidr_blocks` value for SSH access is conditional based on `var.enable_ssh`. If `var.enable_ssh` is `true`, it allows SSH access from anywhere; otherwise, no SSH access is allowed. Ensure `var.enable_ssh` is defined in your `variables.tf` and `*.tfvars` files.

### Example `variables.tf`

Ensure you have corresponding variables defined in your `variables.tf` file:

```hcl
variable "enable_ssh" {
  description = "Enable SSH access"
  type        = bool
  default     = false
}

variable "vpc_id" {
  description = "The VPC ID to create the security group in."
  type        = string
}
```

### Example `dev.tfvars`

Define values for these variables in your environment-specific `.tfvars` file:

```hcl
enable_ssh = true
vpc_id     = "vpc-12345678"  # Replace with your VPC ID
```

### Applying Changes

To apply these changes, ensure you provide the correct `.tfvars` file:

```sh
terraform apply -var-file="dev.tfvars"
```

### Summary

- **Specify VPC ID** if necessary.
- **Add egress rules** to allow outbound traffic.
- **Include tags** for better resource management.
- **Adjust variables and `.tfvars` files** according to your needs.

These adjustments ensure that your security group configuration is complete and ready for various environments.

Conditional expressions in Terraform provide a powerful way to make decisions and customize your infrastructure deployments based on various conditions and variables. They enhance the flexibility and reusability of your Terraform configurations.
