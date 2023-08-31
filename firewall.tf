##############################################################################
#
# Author: Logan Mancuso
# Created: 07.30.2023
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
resource "proxmox_virtual_environment_firewall_alias" "home_network" {
  name    = "private-network"
  cidr    = "192.168.1.0/24"
  comment = "home network"
}
resource "proxmox_virtual_environment_firewall_alias" "vpc" {
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

#######################################
# Node Firewall Policy
#######################################
# resource "proxmox_virtual_environment_cluster_firewall" "node_firewall_policy" {
#   for_each      = var.nodes
#   node_name     = each.key
#   enabled       = true
#   ebtables      = true
#   input_policy  = "DROP"
#   output_policy = "DROP"
#   log_ratelimit {
#     enabled = false
#     burst   = 10
#     rate    = "5/second"
#   }
# }

#######################################
# Datacenter Default Rules
#######################################
resource "proxmox_virtual_environment_firewall_rules" "dc_default" {
  ######################
  ### Inbound Rules ###
  ######################

  ## ProxmoxUI and API ##
  dynamic "rule" {
    for_each = var.nodes
    content {
      type    = "in"
      action  = "ACCEPT"
      comment = "inbound-permit-${rule.key}-proxmoxui"
      source  = "dc/${proxmox_virtual_environment_firewall_alias.home_network.id}"
      sport   = "8806"
      dest    = "dc/${proxmox_virtual_environment_firewall_alias.cluster_alias[rule.key].id}"
      dport   = "8806"
      proto   = "tcp"
      log     = "info"
    }
  }
  ## Packer build ##
  dynamic "rule" {
    for_each = var.nodes
    content {
      type    = "in"
      action  = "ACCEPT"
      comment = "inbound-permit-${rule.key}-packer"
      source  = "dc/${proxmox_virtual_environment_firewall_alias.home_network.id}"
      sport   = "8802"
      dest    = "dc/${proxmox_virtual_environment_firewall_alias.cluster_alias[rule.key].id}"
      dport   = "8802"
      proto   = "tcp"
      log     = "info"
    }
  }
  rule {
    type    = "in"
    action  = "ACCEPT"
    comment = "inbound-permit-vpc-packer"
    source  = "dc/${proxmox_virtual_environment_firewall_alias.home_network.id}"
    sport   = "8802"
    dest    = "dc/${proxmox_virtual_environment_firewall_alias.vpc.id}"
    dport   = "8802"
    proto   = "tcp"
    log     = "info"
  }
  ## SSH ## 
  rule {
    type    = "in"
    action  = "ACCEPT"
    comment = "inbound-permit-private-ssh"
    source  = "dc/${proxmox_virtual_environment_firewall_alias.home_network.id}"
    sport   = "22"
    dport   = "22"
    proto   = "tcp"
    log     = "info"
  }
  rule {
    type    = "in"
    action  = "ACCEPT"
    comment = "inbound-permit-vpc-ssh"
    source  = "dc/${proxmox_virtual_environment_firewall_alias.vpc.id}"
    sport   = "22"
    dest    = "dc/${proxmox_virtual_environment_firewall_alias.vpc.id}"
    dport   = "22"
    proto   = "tcp"
    log     = "info"
  }
  ## ICMP ##
  dynamic "rule" {
    for_each = var.nodes
    content {
      type    = "in"
      action  = "ACCEPT"
      comment = "inbound-permit-${rule.key}-icmp"
      source  = "dc/${proxmox_virtual_environment_firewall_alias.home_network.id}"
      dest    = "dc/${proxmox_virtual_environment_firewall_alias.cluster_alias[rule.key].id}"
      proto   = "icmp"
      log     = "info"
    }
  }
  rule {
    type    = "in"
    action  = "ACCEPT"
    comment = "inbound-permit-private-icmp"
    source  = "dc/${proxmox_virtual_environment_firewall_alias.home_network.id}"
    dest    = "dc/${proxmox_virtual_environment_firewall_alias.vpc.id}"
    proto   = "icmp"
    log     = "info"
  }
  rule {
    type    = "in"
    action  = "ACCEPT"
    comment = "inbound-permit-vpc-icmp"
    source  = "dc/${proxmox_virtual_environment_firewall_alias.vpc.id}"
    dest    = "dc/${proxmox_virtual_environment_firewall_alias.vpc.id}"
    proto   = "icmp"
    log     = "info"
  }

  ######################
  ### Outbound Rules ###
  ######################

  ## ProxmoxUI and API ##
  dynamic "rule" {
    for_each = var.nodes
    content {
      type    = "out"
      action  = "ACCEPT"
      comment = "outbound-permit-${rule.key}-proxmoxui"
      source  = "dc/${proxmox_virtual_environment_firewall_alias.cluster_alias[rule.key].id}"
      sport   = "8806"
      dest    = "dc/${proxmox_virtual_environment_firewall_alias.home_network.id}"
      dport   = "8806"
      proto   = "tcp"
      log     = "info"
    }
  }
  ## Packer build ##
  dynamic "rule" {
    for_each = var.nodes
    content {
      type    = "out"
      action  = "ACCEPT"
      comment = "outbound-permit-${rule.key}-packer"
      source  = "dc/${proxmox_virtual_environment_firewall_alias.cluster_alias[rule.key].id}"
      sport   = "8802"
      dest    = "dc/${proxmox_virtual_environment_firewall_alias.home_network.id}"
      dport   = "8802"
      proto   = "tcp"
      log     = "info"
    }
  }
  rule {
    type    = "out"
    action  = "ACCEPT"
    comment = "outbound-permit-vpc-packer"
    source  = "dc/${proxmox_virtual_environment_firewall_alias.vpc.id}"
    sport   = "8802"
    dest    = "dc/${proxmox_virtual_environment_firewall_alias.home_network.id}"
    dport   = "8802"
    proto   = "tcp"
    log     = "info"
  }
  ## ICMP ##
  rule {
    type    = "out"
    action  = "ACCEPT"
    comment = "outbount-permit-vpc-icmp"
    source  = "dc/${proxmox_virtual_environment_firewall_alias.vpc.id}"
    dest    = "dc/${proxmox_virtual_environment_firewall_alias.vpc.id}"
    proto   = "icmp"
    log     = "info"
  }
  rule {
    type    = "out"
    action  = "ACCEPT"
    comment = "outbount-permit-private-icmp"
    source  = "dc/${proxmox_virtual_environment_firewall_alias.home_network.id}"
    dest    = "dc/${proxmox_virtual_environment_firewall_alias.vpc.id}"
    proto   = "icmp"
    log     = "info"
  }
  rule {
    type    = "out"
    action  = "ACCEPT"
    comment = "outbount-permit-global-icmp"
    source  = "dc/${proxmox_virtual_environment_firewall_alias.vpc.id}"
    dest    = "dc/${proxmox_virtual_environment_firewall_alias.global_network.id}"
    proto   = "icmp"
    log     = "info"
  }
  ## HTTP(S) ##
  rule {
    type    = "out"
    action  = "ACCEPT"
    comment = "outbound-permit-private-https"
    source  = "dc/${proxmox_virtual_environment_firewall_alias.home_network.id}"
    sport   = "443"
    dest    = "dc/${proxmox_virtual_environment_firewall_alias.global_network.id}"
    dport   = "443"
    proto   = "tcp"
    log     = "info"
  }
  rule {
    type    = "out"
    action  = "ACCEPT"
    comment = "outbound-permit-vpc-https"
    source  = "dc/${proxmox_virtual_environment_firewall_alias.vpc.id}"
    sport   = "443"
    dest    = "dc/${proxmox_virtual_environment_firewall_alias.global_network.id}"
    dport   = "443"
    proto   = "tcp"
    log     = "info"
  }
  rule {
    type    = "out"
    action  = "ACCEPT"
    comment = "outbound-permit-private-http"
    source  = "dc/${proxmox_virtual_environment_firewall_alias.home_network.id}"
    sport   = "80"
    dest    = "dc/${proxmox_virtual_environment_firewall_alias.global_network.id}"
    dport   = "80"
    proto   = "tcp"
    log     = "info"
  }
  rule {
    type    = "out"
    action  = "ACCEPT"
    comment = "outbound-permit-vpc-http"
    source  = "dc/${proxmox_virtual_environment_firewall_alias.vpc.id}"
    sport   = "80"
    dest    = "dc/${proxmox_virtual_environment_firewall_alias.global_network.id}"
    dport   = "80"
    proto   = "tcp"
    log     = "info"
  }
  ## DNS ##
  rule {
    type    = "out"
    action  = "ACCEPT"
    comment = "outbound-permit-private-dns"
    source  = "dc/${proxmox_virtual_environment_firewall_alias.home_network.id}"
    sport   = "53"
    dest    = "+${proxmox_virtual_environment_firewall_ipset.dns.id}"
    dport   = "53"
    proto   = "tcp"
    log     = "info"
  }
  rule {
    type    = "out"
    action  = "ACCEPT"
    comment = "outbound-permit-dns"
    source  = "dc/${proxmox_virtual_environment_firewall_alias.vpc.id}"
    sport   = "53"
    dest    = "+${proxmox_virtual_environment_firewall_ipset.dns.id}"
    dport   = "53"
    proto   = "tcp"
    log     = "info"
  }
  depends_on = [
    proxmox_virtual_environment_firewall_ipset.dns,
    proxmox_virtual_environment_firewall_alias.global_network,
    proxmox_virtual_environment_firewall_alias.vpc,
    proxmox_virtual_environment_firewall_alias.home_network
  ]
}
