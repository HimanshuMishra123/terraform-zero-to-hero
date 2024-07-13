# Managing different workspaces(dev, stage, prod) using lookup(map,key) but which method is best for you depends upon variousthings..Read > tfvars vs lookup for workspace application.md

provider "aws" {
  region = "us-east-1"
}

variable "ami" {
  description = "value"
}

variable "instance_type" {
  description = "value"
  type = map(string)

  default = {
    "dev" = "t2.micro"
    "stage" = "t2.medium"
    "prod" = "t2.xlarge"
  }
}

module "ec2_instance" {
  source = "./modules/ec2_instance"
  ami = var.ami
  instance_type = lookup(var.instance_type, terraform.workspace, "t2.micro")   # terrafor.workspace will give value of presnt eorkspace, 3rd value is default value if no workspace is defined
}

