# Terraform Proxmox

This workflow deploys the basic datacenter infrastructure for proxmox with a single node. 

## Instance Numbering Convention

Proxmox uses numerical id's to distinguish resources. This outlines the basic convention to use when id'ing a resource. 

images will be prefixed with '00'
lxc containers will have a prefix of '10'
vms will have a prefix of '20'

resource  | [0-9] | [0-9] | [0-9] | [0-9] | [0-9] |
---       |  ---  |  ---  |  ---  |  ---  |  ---  |
image     |   0   |   0   | [0-9] | [0-9] | [0-9] |
lxc       |   1   |   0   | [0-9] | [0-9] | [0-9] |
vm        |   2   |   0   | [0-9] | [0-9] | [0-9] |

## PreDeployment

set these secret variables in your environment, i use a file called proxmox.env and run `source proxmox.env` to load the values into my shell
```bash
export PROXMOX_VE_PASSWORD={this is your root password for proxmox}
export TF_HTTP_PASSWORD={this is your github api key to sync the tf state}
export PROXMOX_TOKEN={this is the api token generated for proxmox ops user created in this workflow}
```

## Usage
to deploy this workflow link the environment tfvars folder to the root directory. 
```bash
  ln -s env/{node_name}/main.tf
  ln -s env/{node_name}/terraform.tfvars
  ln -s env/{node_name}/hosts

  tofu init .
  tofu plan
  tofu apply
```

## Post Deploy
add the root cert as trusted on the local machine
```bash
openssl x509 -in ./keys/root/cert-authority.pem -inform PEM -out ./keys/root/cert-authority.crt
openssl x509 -in ./keys/client/cert-intranet.pem -inform PEM -out ./keys/client/cert-intranet.crt
sudo cp ./keys/root/cert-authority.crt /usr/local/share/ca-certificates/cert-authority.crt
sudo cp ./keys/client/cert-intranet.crt /usr/local/share/ca-certificates/cert-intranet.crt
sudo update-ca-certificates --fresh
```
add the unlock tokens to the proxmox.env for export variables, then resource it using `source proxmox.env`
```bash
export VAULT_ADDR='https://localhost:8200'
export VAULT_CAPATH=/usr/local/share/ca-certificates/cert-intranet.crt
export VAULT_DEV_ROOT_TOKEN_ID=hvs.XXXXXXXXXXXXXXXXXXXXXX
export UNSEAL_KEY_1=XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX
export UNSEAL_KEY_2=XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX
export UNSEAL_KEY_3=XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX
```
