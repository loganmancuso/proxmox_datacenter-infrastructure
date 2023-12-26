# Terraform Proxmox

This workflow deploys the basic datacenter infrastructure for proxmox with a single node. 

##### Dependancies
- loganmancuso_infrastructure/proxmox/global-secrets>

## Getting Started
If you do not already have [opentofu](https://opentofu.org/) or [terraform](https://www.terraform.io/) installed, please reference the source documents to install the tools. This project is a terraform automation to build out a proxmox cluster, right now the testing has only been pushed to one node. There is a plan to split this workflow into a datacenter-infrastructure and a node-infrastructure. 

### Known issues
I originally tried to develop this project on windows 11 with the WSL however packer on WSL has some trouble with the networking. I would recommend to run these workflows from a proper linux machine.   

### Conventions
---
#### Instance Numbering 

Proxmox uses numerical id's to distinguish resources. This outlines the basic convention to use when id'ing a resource. 
- images will be prefixed with '00'
- lxc containers will have a prefix of '10'
- vms will have a prefix of '20'

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

## Deployment
to deploy this workflow link the environment tfvars folder to the root directory. 
```bash
  ln -s env/{node_name}/* .
  tofu init .
  tofu plan
  tofu apply
```

## Post Deployment
it is likely that the vmbr0 is already configured and this workflow will error on first execution.
```
╷
│ Error: Error creating Linux Bridge interface
│ 
│   with proxmox_virtual_environment_network_linux_bridge.vmbr0,
│   on network.tf line 79, in resource "proxmox_virtual_environment_network_linux_bridge" "vmbr0":
│   79: resource "proxmox_virtual_environment_network_linux_bridge" "vmbr0" {
│ 
│ Could not create Linux Bridge, unexpected error: failed to create network interface "vmbr0" for node "pve-test": received an HTTP 400
│ response - Reason: Parameter verification failed. (iface: interface already exists)
```
to fix this you will need to import the virtual bridge into the terraform state to manage it through the automation. 
```bash
tf import proxmox_virtual_environment_network_linux_bridge.vmbr0 {node-name}:{vmbr name} pve-test:vmbr0
```
a successful import will look like this:
```
tf import proxmox_virtual_environment_network_linux_bridge.vmbr0 pve-test:vmbr0
data.terraform_remote_state.hashicorp_vault: Reading...
proxmox_virtual_environment_network_linux_bridge.vmbr0: Importing from ID "pve-test:vmbr0"...
data.proxmox_virtual_environment_nodes.available_nodes: Reading...
data.proxmox_virtual_environment_roles.available_roles: Reading...
data.proxmox_virtual_environment_nodes.available_nodes: Read complete after 0s [id=nodes]
proxmox_virtual_environment_network_linux_bridge.vmbr0: Import prepared!
  Prepared proxmox_virtual_environment_network_linux_bridge for import
proxmox_virtual_environment_network_linux_bridge.vmbr0: Refreshing state... [id=pve-test:vmbr0]
data.proxmox_virtual_environment_roles.available_roles: Read complete after 0s [id=roles]
data.terraform_remote_state.hashicorp_vault: Read complete after 1s

Import successful!

The resources that were imported are shown above. These resources are now in
your OpenTofu state and will henceforth be managed by OpenTofu.
``` 

#### Special Thanks:
This [project](https://github.com/bpg/terraform-provider-proxmox/tree/main) has been a huge foundation on which to build this automation, please consider sponsoring [Pavel Boldyrev](https://github.com/bpg)