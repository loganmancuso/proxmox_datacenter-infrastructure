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
  required_version = ">= 0.13.0"
  required_providers {
    proxmox = {
      source  = "bpg/proxmox"
      version = ">= 0.30.1"
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