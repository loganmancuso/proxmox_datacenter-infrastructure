##############################################################################
#
# Author: Logan Mancuso
# Created: 11.27.2023
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
resource "proxmox_virtual_environment_certificate" "node_cert" {
  node_name   = var.node_name
  certificate = tls_locally_signed_cert.intranet.cert_pem
  private_key = tls_private_key.client.private_key_pem
}

#######################################
# Ansible Bootstrap Node
#######################################
resource "null_resource" "ansible_bootstrap" {
  provisioner "local-exec" {
    command = "ansible-playbook -i ./hosts scripts/bootstrap.yaml -vvvv"
  }
}