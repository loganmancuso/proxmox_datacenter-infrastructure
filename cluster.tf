##############################################################################
#
# Author: Logan Mancuso
# Created: 07.30.2023
#
##############################################################################

resource "proxmox_virtual_environment_time" "node_time" {
  node_name = var.node_name
  time_zone = "America/New_York"
}

#######################################
# Cluster Alias
#######################################
resource "proxmox_virtual_environment_firewall_alias" "cluster_alias" {
  name    = var.node_name
  cidr    = "${var.node_ip}/24"
  comment = "alias"
}

#######################################
# Cert Management
#######################################

resource "tls_private_key" "proxmox_virtual_environment_certificate" {
  algorithm = "RSA"
  rsa_bits  = 4096
}

resource "local_file" "proxmox_virtual_environment_certificate" {
  filename = "resources/private-key.pem"
  content  = tls_private_key.proxmox_virtual_environment_certificate.private_key_pem
}

resource "tls_self_signed_cert" "proxmox_virtual_environment_certificate" {
  private_key_pem = tls_private_key.proxmox_virtual_environment_certificate.private_key_pem
  subject {
    common_name  = "${var.node_name}.local"
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
  node_name   = var.node_name
  certificate = tls_self_signed_cert.proxmox_virtual_environment_certificate.cert_pem
  private_key = tls_private_key.proxmox_virtual_environment_certificate.private_key_pem
}

#######################################
# Ansible Bootstrap Node
#######################################
resource "null_resource" "ansible_bootstrap" {
  provisioner "local-exec" {
    command = "ansible-playbook -i ./hosts scripts/bootstrap.yaml -vvvv"
  }
}