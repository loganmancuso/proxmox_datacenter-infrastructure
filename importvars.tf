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