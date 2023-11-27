##############################################################################
#
# Author: Logan Mancuso
# Created: 11.27.2023
#
##############################################################################

#######################################
# Network Aliases
#######################################

resource "proxmox_virtual_environment_firewall_alias" "global_network" {
  name    = "global-network"
  cidr    = "0.0.0.0/0"
  comment = "global network"
}
resource "proxmox_virtual_environment_firewall_alias" "private_network" {
  name    = "private-network"
  cidr    = "192.168.1.0/24"
  comment = "home network"
}
resource "proxmox_virtual_environment_firewall_alias" "iot_network" {
  name    = "iot-network"
  cidr    = "192.168.3.0/24"
  comment = "iot network"
}
resource "proxmox_virtual_environment_firewall_alias" "vpc_network" {
  name    = "vpc-network"
  cidr    = "192.168.10.0/24"
  comment = "vpc network"
}

#######################################
# IP Sets
#######################################
resource "proxmox_virtual_environment_firewall_ipset" "dns" {
  name    = "preferred-dns"
  comment = "dns servers"
  dynamic "cidr" {
    for_each = var.dns_servers
    content {
      comment = cidr.key
      name    = cidr.value
    }
  }
  lifecycle {
    ignore_changes = [cidr]
  }
}

#######################################
# Datacenter Firewall Policy
#######################################
resource "proxmox_virtual_environment_cluster_firewall" "dc_firewall_policy" {
  enabled       = true
  ebtables      = true
  input_policy  = "DROP"
  output_policy = "ACCEPT"
  log_ratelimit {
    enabled = false
    burst   = 10
    rate    = "5/second"
  }
}

# #######################################
# # Datacenter Default Rules
# #######################################
resource "proxmox_virtual_environment_firewall_rules" "dc_default" {
  ######################
  ### Inbound Rules ###
  ######################
  rule {
    security_group = proxmox_virtual_environment_cluster_firewall_security_group.dc_default.name
  }
  # Default DROP Rule
  rule {
    type    = "in"
    action  = "DROP"
    comment = "inbound-default-drop"
    log     = "alert"
  }
  ######################
  ### Outbound Rules ###
  ######################
}
