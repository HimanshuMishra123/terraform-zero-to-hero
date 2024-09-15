# Vault Integration

Here are the detailed steps for each of these steps:

## Create an AWS EC2 instance with Ubuntu

To create an AWS EC2 instance with Ubuntu, you can use the AWS Management Console or the AWS CLI. Here are the steps involved in creating an EC2 instance using the AWS Management Console:

- Go to the AWS Management Console and navigate to the EC2 service.
- Click on the Launch Instance button.
- Select the Ubuntu Server xx.xx LTS AMI.
- Select the instance type that you want to use.
- Configure the instance settings.
- Click on the Launch button.

## Install Vault on the EC2 instance

To install Vault on the EC2 instance, you can use the following steps:

**Install gpg(hashicorp package manager)**

```
sudo apt update && sudo apt install gpg
```

**Download the signing key to a new keyring**

```
wget -O- https://apt.releases.hashicorp.com/gpg | sudo gpg --dearmor -o /usr/share/keyrings/hashicorp-archive-keyring.gpg
```

**Verify the key's fingerprint**

```
gpg --no-default-keyring --keyring /usr/share/keyrings/hashicorp-archive-keyring.gpg --fingerprint
```

**Add the HashiCorp repo**

```
echo "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/hashicorp-archive-keyring.gpg] https://apt.releases.hashicorp.com $(lsb_release -cs) main" | sudo tee /etc/apt/sources.list.d/hashicorp.list
```

```
sudo apt update
```

**Finally, Install Vault**

```
sudo apt install vault
```

**To check if vault is installed**
``
vault
``

## To Start Vault server.

To start Vault server, Vault comes in two different variations one is you can start the production server or you can start the development server for proof of Concepts and demonstrations. You can use the development server(just like minikube for k8s) it has the features that are required and there is no problem in using it but when you're using in your organization you need to use the production instance you need to attach TLS and certificates and you need to create the production grade instance(EC2). <br/>

To start devlopment Vault server, you can use the following command:

```
vault server -dev -dev-listen-address="0.0.0.0:8200"

```
Take a different tab and ssh to ec2 and give command... 
```sh 
export VAULT_ADDR='http://0.0.0.0:8200'
```
Now enable port 8200 in EC2 instance security group inbound traffic.<br/>
Go to browser and search .... Public_ip:8200 <br/>
vault UI will appear.. There Multiple methods/way for organization to authenticate and integrate with your Vault with existing userbase but for demo purpose we will use root token generated while running Vault development server. Using which we will get root access to Hashicorp vault UI.<br/>

Secrets Engine : Jis bhi chij ke secrets bnane hai example : K8s, Clouds, databses, KV(key value)<br/>
Enable new engine>>select secret engine>>add any name to "path"(this will create a mount/folder)>>create secret>> Path for this secret(any name), secret data (key value pair)>>save <br/>

Access : In access you define how you will authenticate, most widely used method is Approle(similiar to Iam Role).you are telling hashicorp that I want to use app roll based authentication so I will authenticate terraform or anible or anything using this app roll mechanism. for this you can use the Vault CLI or the Vault HTTP API (UI). from UI below are the steps- <br/> 
Enable new method>> AppRole>>next>>enable method<br/>

Policies: refer below Vault CLLI method

## Configure Terraform to read the secret from Vault.

Detailed steps to enable and configure AppRole authentication in HashiCorp Vault:

1. **Enable AppRole Authentication**:

To enable the AppRole authentication method in Vault, you need to use the Vault CLI or the Vault HTTP API.

**Using Vault CLI**:

Run the following command to enable the AppRole authentication method:

```bash
vault auth enable approle
```

This command tells Vault to enable the AppRole authentication method.

2. **Create an AppRole**:

We need to create policy first(similiar to IAM policy, this you can get from Vault document just use it),

```
vault policy write terraform - <<EOF
path "*" {
  capabilities = ["list", "read"]
}

path "secrets/data/*" {
  capabilities = ["create", "read", "update", "delete", "list"]
}

path "kv/data/*" {
  capabilities = ["create", "read", "update", "delete", "list"]
}


path "secret/data/*" {
  capabilities = ["create", "read", "update", "delete", "list"]
}

path "auth/token/create" {
capabilities = ["create", "read", "update", "list"]
}
EOF
```

Now you'll need to create an AppRole with appropriate policies and configure its authentication settings. Here are the steps to create an AppRole:

**a. Create the AppRole(Similiar to Iam role)**:

```bash
vault write auth/approle/role/terraform \
    secret_id_ttl=10m \
    token_num_uses=10 \
    token_ttl=20m \
    token_max_ttl=30m \
    secret_id_num_uses=40 \
    token_policies=terraform
```

3. **Generate Role ID and Secret ID**:

After creating the AppRole, you need to generate a Role ID and Secret ID pair. The Role ID is a static identifier, while the Secret ID is a dynamic credential.

**a. Generate Role ID**:

You can retrieve the Role ID using the Vault CLI:

```bash
vault read auth/approle/role/my-approle/role-id
```

Save the Role ID for use in your Terraform configuration.

**b. Generate Secret ID**:

To generate a Secret ID, you can use the following command:

```bash
vault write -f auth/approle/role/my-approle/secret-id
   ```

This command generates a Secret ID and provides it in the response. Save the Secret ID securely, as it will be used for Terraform authentication.