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

## Authentication

set these secret variables in your environment
```
export PROXMOX_VE_PASSWORD={this is your root password for proxmox}
export TF_HTTP_PASSWORD={this is your github api key to sync the tf state}
export PROXMOX_TOKEN={this is the api token generated for proxmox ops user created in this workflow}
```

## Usage
to deploy this workflow link the environment tfvars folder to the root directory. 
```
  ln -s env/{node_name}/main.tf
  ln -s env/{node_name}/terraform.tfvars
  ln -s env/{node_name}/hosts

  tofu init .
  tofu plan
  tofu apply
```
