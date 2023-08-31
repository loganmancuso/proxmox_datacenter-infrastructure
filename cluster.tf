##############################################################################
#
# Author: Logan Mancuso
# Created: 07.30.2023
#
##############################################################################

resource "proxmox_virtual_environment_time" "node_time" {
  for_each  = var.nodes
  node_name = each.key
  time_zone = "America/New_York"
}

#######################################
# Cluster Alias
#######################################
resource "proxmox_virtual_environment_firewall_alias" "cluster_alias" {
  for_each = var.nodes
  name     = each.key
  cidr     = "${each.value}/24"
  comment  = "alias"
}

#######################################
# Cert Management
#######################################

resource "tls_private_key" "proxmox_virtual_environment_certificate" {
  algorithm = "RSA"
  rsa_bits  = 4096
}

resource "tls_self_signed_cert" "proxmox_virtual_environment_certificate" {
  for_each        = var.nodes
  private_key_pem = tls_private_key.proxmox_virtual_environment_certificate.private_key_pem
  subject {
    common_name  = "${each.key}.local"
    organization = "loganmancuso"
  }
  validity_period_hours = 8760
  allowed_uses = [
    "key_encipherment",
    "digital_signature",
    "server_auth",
  ]
}

resource "proxmox_virtual_environment_certificate" "node_cert" {
  for_each    = var.nodes
  node_name   = each.key
  certificate = tls_self_signed_cert.proxmox_virtual_environment_certificate[each.key].cert_pem
  private_key = tls_private_key.proxmox_virtual_environment_certificate.private_key_pem
}

#######################################
# Ansible Bootstrap Node
#######################################
resource "null_resource" "ansible_bootstrap" {
  provisioner "local-exec" {
    command = "ansible-playbook -i scripts/hosts scripts/bootstrap.yml"
  }
}