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

data "terraform_remote_state" "global_secrets" {
  backend = "http"
  config = {
    address  = "https://gitlab.com/api/v4/projects/52104036/terraform/state/global-secrets"
    username = "loganmancuso"
  }
}

locals {
  # hashicorp_vault
  cert_root       = data.terraform_remote_state.global_secrets.outputs.cert_root
  root_priv_key   = data.terraform_remote_state.global_secrets.outputs.root_priv_key
  cert_intranet   = data.terraform_remote_state.global_secrets.outputs.cert_intranet
  client_priv_key = data.terraform_remote_state.global_secrets.outputs.client_priv_key
  client_pub_key  = data.terraform_remote_state.global_secrets.outputs.client_pub_key
}
