provider "aws" {
  region = "us-east-1"
}

#Vault Provider,in path authenticate using approle for login
provider "vault" {
  address = "<>:8200"
  skip_child_token = true

  auth_login {
    path = "auth/approle/login"    

    parameters = {
      role_id = "<>"
      secret_id = "<>"
    }
  }
}


# Below will return data from Vault in form of list which you have to iterate through to use it
data "vault_kv_secret_v2" "example" {
  mount = "secret" // change it according to your mount
  name  = "test-secret" // change it according to your secret
}

resource "aws_instance" "my_instance" {
  ami           = "ami-053b0d53c279acc90"
  instance_type = "t2.micro"

  tags = {
    Name = "test"
    Secret = data.vault_kv_secret_v2.example.data["foo"]  //use key in place of foo as per Vault
  }
}
