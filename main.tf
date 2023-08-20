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
      version = ">= 0.29.0"
    }
    ansible = {
      version = ">= 1.1.0"
      source  = "ansible/ansible"
    }
  }
  backend "local" {
    path = "datacenter-infrastructure.tfstate"
  }
}

provider "proxmox" {
  endpoint = "https://${var.endpoint}:8006/"
  username = "root@pam"
  password = var.root_password
  # (Optional) Skip TLS Verification
  insecure = true
  ssh {
    agent    = true
    username = "root"
    dynamic "node" {
      for_each = var.nodes
      content {
        name    = node.key
        address = node.value
      }
    }
  }
}