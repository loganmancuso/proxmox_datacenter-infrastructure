##############################################################################
#
# Author: Logan Mancuso
# Created: 11.27.2023
#
##############################################################################

data "proxmox_virtual_environment_roles" "available_roles" {}
data "proxmox_virtual_environment_nodes" "available_nodes" {}

locals {
  available_nodes = data.proxmox_virtual_environment_nodes.available_nodes
}

data "terraform_remote_state" "hashicorp_vault" {
  backend = "http"
  config = {
    address  = "https://gitlab.com/api/v4/projects/52530007/terraform/state/hashicorp-vault"
    username = "loganmancuso"
  }
}

locals {
  # hashicorp_vault
  cert_root       = data.terraform_remote_state.hashicorp_vault.outputs.cert_root
  root_priv_key   = data.terraform_remote_state.hashicorp_vault.outputs.root_priv_key
  cert_intranet   = data.terraform_remote_state.hashicorp_vault.outputs.cert_intranet
  client_priv_key = data.terraform_remote_state.hashicorp_vault.outputs.client_priv_key
  client_pub_key  = data.terraform_remote_state.hashicorp_vault.outputs.client_pub_key
}
