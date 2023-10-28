##############################################################################
#
# Author: Logan Mancuso
# Created: 07.30.2023
#
##############################################################################

data "proxmox_virtual_environment_roles" "available_roles" {}
data "proxmox_virtual_environment_nodes" "available_nodes" {}

locals {
  workspace       = terraform.workspace
  available_nodes = data.proxmox_virtual_environment_nodes.available_nodes
}