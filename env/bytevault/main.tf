##############################################################################
#
# Author: Logan Mancuso
# Created: 07.30.2023
#
##############################################################################

#######################################
# Provider
#######################################

terraform {
  required_version = ">= 1.6.0"
  required_providers {
    proxmox = {
      source  = "bpg/proxmox"
      version = ">= 0.37.0"
    }
  }
  backend "http" {
    address  = "https://gitlab.com/api/v4/projects/48634510/terraform/state/bytevault"
    username = "loganmancuso"
  }
}

provider "random" {}

provider "proxmox" {
  endpoint = "https://${var.node_ip}:8006/"
  username = "root@pam"
  password = local.credentials_proxmox.root_password
  # (Optional) Skip TLS Verification
  insecure = true
  ssh {
    agent    = true
    username = "root"
    node {
      name    = var.node_name
      address = var.node_ip
    }
  }
}