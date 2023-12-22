##############################################################################
#
# Author: Logan Mancuso
# Created: 11.27.2023
#
##############################################################################

#######################################
# Datacenter Default Rules
#######################################
resource "proxmox_virtual_environment_cluster_firewall_security_group" "dc_default" {
  name    = "sg-datacenter"
  comment = "Default Datacenter Security Group"

  ######################
  ### Inbound Rules ###
  ######################

  ## ProxmoxUI and API ##
  rule {
    type    = "in"
    action  = "ACCEPT"
    comment = "inbound-permit-${var.node_name}-proxmoxui"
    source  = "dc/${proxmox_virtual_environment_firewall_alias.private_network.id}"
    dest    = "dc/${proxmox_virtual_environment_firewall_alias.cluster_alias.id}"
    dport   = "8006"
    proto   = "tcp"
    log     = "alert"
  }
  ## Packer build ##
  rule {
    type    = "in"
    action  = "ACCEPT"
    comment = "inbound-permit-${var.node_name}-packer"
    source  = "dc/${proxmox_virtual_environment_firewall_alias.private_network.id}"
    dest    = "dc/${proxmox_virtual_environment_firewall_alias.cluster_alias.id}"
    dport   = "8802"
    proto   = "tcp"
    log     = "alert"
  }
  rule {
    type    = "in"
    action  = "ACCEPT"
    comment = "inbound-permit-vpc-packer"
    source  = "dc/${proxmox_virtual_environment_firewall_alias.private_network.id}"
    dest    = "dc/${proxmox_virtual_environment_firewall_alias.vpc_network.id}"
    dport   = "8802"
    proto   = "tcp"
    log     = "alert"
  }
  ## SSH ## 
  rule {
    type    = "in"
    action  = "ACCEPT"
    comment = "inbound-permit-private-ssh"
    source  = "dc/${proxmox_virtual_environment_firewall_alias.private_network.id}"
    dport   = "22"
    proto   = "tcp"
    log     = "alert"
  }
  rule {
    type    = "in"
    action  = "ACCEPT"
    comment = "inbound-permit-vpc-ssh"
    source  = "dc/${proxmox_virtual_environment_firewall_alias.vpc_network.id}"
    dest    = "dc/${proxmox_virtual_environment_firewall_alias.vpc_network.id}"
    dport   = "22"
    proto   = "tcp"
    log     = "alert"
  }
  ## ICMP ##
  rule {
    type    = "in"
    action  = "ACCEPT"
    comment = "inbound-permit-${var.node_name}-icmp"
    source  = "dc/${proxmox_virtual_environment_firewall_alias.private_network.id}"
    dest    = "dc/${proxmox_virtual_environment_firewall_alias.cluster_alias.id}"
    proto   = "icmp"
    log     = "alert"
  }
  rule {
    type    = "in"
    action  = "ACCEPT"
    comment = "inbound-permit-private-icmp"
    source  = "dc/${proxmox_virtual_environment_firewall_alias.private_network.id}"
    dest    = "dc/${proxmox_virtual_environment_firewall_alias.vpc_network.id}"
    proto   = "icmp"
    log     = "alert"
  }
  rule {
    type    = "in"
    action  = "ACCEPT"
    comment = "inbound-permit-vpc-icmp"
    source  = "dc/${proxmox_virtual_environment_firewall_alias.vpc_network.id}"
    dest    = "dc/${proxmox_virtual_environment_firewall_alias.vpc_network.id}"
    proto   = "icmp"
    log     = "alert"
  }

  ######################
  ### Outbound Rules ###
  ######################

  ## ProxmoxUI and API ##
  rule {
    type    = "out"
    action  = "ACCEPT"
    comment = "outbound-permit-${var.node_name}-proxmoxui"
    source  = "dc/${proxmox_virtual_environment_firewall_alias.cluster_alias.id}"
    dest    = "dc/${proxmox_virtual_environment_firewall_alias.private_network.id}"
    dport   = "8006"
    proto   = "tcp"
    log     = "alert"
  }
  ## Packer build ##
  rule {
    type    = "out"
    action  = "ACCEPT"
    comment = "outbound-permit-${var.node_name}-packer"
    source  = "dc/${proxmox_virtual_environment_firewall_alias.cluster_alias.id}"
    dest    = "dc/${proxmox_virtual_environment_firewall_alias.private_network.id}"
    dport   = "8802"
    proto   = "tcp"
    log     = "alert"
  }
  rule {
    type    = "out"
    action  = "ACCEPT"
    comment = "outbound-permit-vpc-packer"
    source  = "dc/${proxmox_virtual_environment_firewall_alias.vpc_network.id}"
    dest    = "dc/${proxmox_virtual_environment_firewall_alias.private_network.id}"
    dport   = "8802"
    proto   = "tcp"
    log     = "alert"
  }
  ## ICMP ##
  rule {
    type    = "out"
    action  = "ACCEPT"
    comment = "outbount-permit-vpc-icmp"
    source  = "dc/${proxmox_virtual_environment_firewall_alias.vpc_network.id}"
    dest    = "dc/${proxmox_virtual_environment_firewall_alias.vpc_network.id}"
    proto   = "icmp"
    log     = "alert"
  }
  rule {
    type    = "out"
    action  = "ACCEPT"
    comment = "outbount-permit-private-icmp"
    source  = "dc/${proxmox_virtual_environment_firewall_alias.private_network.id}"
    dest    = "dc/${proxmox_virtual_environment_firewall_alias.vpc_network.id}"
    proto   = "icmp"
    log     = "alert"
  }
  rule {
    type    = "out"
    action  = "ACCEPT"
    comment = "outbount-permit-global-icmp"
    source  = "dc/${proxmox_virtual_environment_firewall_alias.vpc_network.id}"
    dest    = "dc/${proxmox_virtual_environment_firewall_alias.global_network.id}"
    proto   = "icmp"
    log     = "alert"
  }
  ## HTTP(S) ##
  rule {
    type    = "out"
    action  = "ACCEPT"
    comment = "outbound-permit-private-https"
    source  = "dc/${proxmox_virtual_environment_firewall_alias.private_network.id}"
    dest    = "dc/${proxmox_virtual_environment_firewall_alias.global_network.id}"
    dport   = "443"
    proto   = "tcp"
    log     = "alert"
  }
  rule {
    type    = "out"
    action  = "ACCEPT"
    comment = "outbound-permit-vpc-https"
    source  = "dc/${proxmox_virtual_environment_firewall_alias.vpc_network.id}"
    dest    = "dc/${proxmox_virtual_environment_firewall_alias.global_network.id}"
    dport   = "443"
    proto   = "tcp"
    log     = "alert"
  }
  rule {
    type    = "out"
    action  = "ACCEPT"
    comment = "outbound-permit-private-http"
    source  = "dc/${proxmox_virtual_environment_firewall_alias.private_network.id}"
    dest    = "dc/${proxmox_virtual_environment_firewall_alias.global_network.id}"
    dport   = "80"
    proto   = "tcp"
    log     = "alert"
  }
  rule {
    type    = "out"
    action  = "ACCEPT"
    comment = "outbound-permit-vpc-http"
    source  = "dc/${proxmox_virtual_environment_firewall_alias.vpc_network.id}"
    dest    = "dc/${proxmox_virtual_environment_firewall_alias.global_network.id}"
    dport   = "80"
    proto   = "tcp"
    log     = "alert"
  }
  ## DNS ##
  rule {
    type    = "out"
    action  = "ACCEPT"
    comment = "outbound-permit-private-dns"
    source  = "dc/${proxmox_virtual_environment_firewall_alias.private_network.id}"
    dest    = "+${proxmox_virtual_environment_firewall_ipset.dns.id}"
    dport   = "53"
    proto   = "tcp"
    log     = "alert"
  }
  rule {
    type    = "out"
    action  = "ACCEPT"
    comment = "outbound-permit-vpc-dns"
    source  = "dc/${proxmox_virtual_environment_firewall_alias.vpc_network.id}"
    dest    = "+${proxmox_virtual_environment_firewall_ipset.dns.id}"
    dport   = "53"
    proto   = "tcp"
    log     = "alert"
  }
}

#######################################
# VM/LXC Default Rules
#######################################
resource "proxmox_virtual_environment_cluster_firewall_security_group" "vm_default" {
  name    = "sg-vmdefault"
  comment = "Default VM Security Group"

  ######################
  ### Inbound Rules ###
  ######################

  ## SSH ## 
  rule {
    type    = "in"
    action  = "ACCEPT"
    comment = "inbound-permit-private-ssh"
    source  = "dc/${proxmox_virtual_environment_firewall_alias.private_network.id}"
    dport   = "22"
    proto   = "tcp"
    log     = "alert"
  }
  rule {
    type    = "in"
    action  = "ACCEPT"
    comment = "inbound-permit-vpc-ssh"
    source  = "dc/${proxmox_virtual_environment_firewall_alias.vpc_network.id}"
    dest    = "dc/${proxmox_virtual_environment_firewall_alias.vpc_network.id}"
    dport   = "22"
    proto   = "tcp"
    log     = "alert"
  }
  ## ICMP ##

  rule {
    type    = "in"
    action  = "ACCEPT"
    comment = "inbound-permit-${var.node_name}-icmp"
    source  = "dc/${proxmox_virtual_environment_firewall_alias.private_network.id}"
    dest    = "dc/${proxmox_virtual_environment_firewall_alias.cluster_alias.id}"
    proto   = "icmp"
    log     = "alert"
  }
  rule {
    type    = "in"
    action  = "ACCEPT"
    comment = "inbound-permit-private-icmp"
    source  = "dc/${proxmox_virtual_environment_firewall_alias.private_network.id}"
    dest    = "dc/${proxmox_virtual_environment_firewall_alias.vpc_network.id}"
    proto   = "icmp"
    log     = "alert"
  }
  rule {
    type    = "in"
    action  = "ACCEPT"
    comment = "inbound-permit-vpc-icmp"
    source  = "dc/${proxmox_virtual_environment_firewall_alias.vpc_network.id}"
    dest    = "dc/${proxmox_virtual_environment_firewall_alias.vpc_network.id}"
    proto   = "icmp"
    log     = "alert"
  }

  ######################
  ### Outbound Rules ###
  ######################

  ## ICMP ##
  rule {
    type    = "out"
    action  = "ACCEPT"
    comment = "outbount-permit-vpc-icmp"
    source  = "dc/${proxmox_virtual_environment_firewall_alias.vpc_network.id}"
    dest    = "dc/${proxmox_virtual_environment_firewall_alias.vpc_network.id}"
    proto   = "icmp"
    log     = "alert"
  }
  rule {
    type    = "out"
    action  = "ACCEPT"
    comment = "outbount-permit-private-icmp"
    source  = "dc/${proxmox_virtual_environment_firewall_alias.private_network.id}"
    dest    = "dc/${proxmox_virtual_environment_firewall_alias.vpc_network.id}"
    proto   = "icmp"
    log     = "alert"
  }
  rule {
    type    = "out"
    action  = "ACCEPT"
    comment = "outbount-permit-global-icmp"
    source  = "dc/${proxmox_virtual_environment_firewall_alias.vpc_network.id}"
    dest    = "dc/${proxmox_virtual_environment_firewall_alias.global_network.id}"
    proto   = "icmp"
    log     = "alert"
  }
  ## HTTP(S) ##
  rule {
    type    = "out"
    action  = "ACCEPT"
    comment = "outbound-permit-private-https"
    source  = "dc/${proxmox_virtual_environment_firewall_alias.private_network.id}"
    dest    = "dc/${proxmox_virtual_environment_firewall_alias.global_network.id}"
    dport   = "443"
    proto   = "tcp"
    log     = "alert"
  }
  rule {
    type    = "out"
    action  = "ACCEPT"
    comment = "outbound-permit-vpc-https"
    source  = "dc/${proxmox_virtual_environment_firewall_alias.vpc_network.id}"
    dest    = "dc/${proxmox_virtual_environment_firewall_alias.global_network.id}"
    dport   = "443"
    proto   = "tcp"
    log     = "alert"
  }
  rule {
    type    = "out"
    action  = "ACCEPT"
    comment = "outbound-permit-private-http"
    source  = "dc/${proxmox_virtual_environment_firewall_alias.private_network.id}"
    dest    = "dc/${proxmox_virtual_environment_firewall_alias.global_network.id}"
    dport   = "80"
    proto   = "tcp"
    log     = "alert"
  }
  rule {
    type    = "out"
    action  = "ACCEPT"
    comment = "outbound-permit-vpc-http"
    source  = "dc/${proxmox_virtual_environment_firewall_alias.vpc_network.id}"
    dest    = "dc/${proxmox_virtual_environment_firewall_alias.global_network.id}"
    dport   = "80"
    proto   = "tcp"
    log     = "alert"
  }
  ## DNS ##
  rule {
    type    = "out"
    action  = "ACCEPT"
    comment = "outbound-permit-private-dns"
    source  = "dc/${proxmox_virtual_environment_firewall_alias.private_network.id}"
    dest    = "+${proxmox_virtual_environment_firewall_ipset.dns.id}"
    dport   = "53"
    proto   = "tcp"
    log     = "alert"
  }
  rule {
    type    = "out"
    action  = "ACCEPT"
    comment = "outbound-permit-dns"
    source  = "dc/${proxmox_virtual_environment_firewall_alias.vpc_network.id}"
    dest    = "+${proxmox_virtual_environment_firewall_ipset.dns.id}"
    dport   = "53"
    proto   = "tcp"
    log     = "alert"
  }
}
