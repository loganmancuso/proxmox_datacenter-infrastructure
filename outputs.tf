##############################################################################
#
# Author: Logan Mancuso
# Created: 07.30.2023
#
##############################################################################

########################
#  DC Variables
########################
output "node_parameters" {
  description = "Node details"
  value       = local.available_nodes
}

output "node_name" {
  description = "node name"
  value       = var.node_name
}

output "node_ip" {
  description = "node ip"
  value       = var.node_ip
}

########################
#  User Variables
########################
output "operations_role" {
  description = "operations role"
  value       = proxmox_virtual_environment_role.operations_team.role_id
}

output "operations_user" {
  description = "operations user"
  value       = proxmox_virtual_environment_user.operations_automation.user_id
}

output "operations_user_password" {
  description = "operations password"
  sensitive   = true
  value       = proxmox_virtual_environment_user.operations_automation.password
}

########################
#  Network Variables
########################

output "preferred_dns" {
  description = "List of configured DNS servers"
  value       = [for dns_server in proxmox_virtual_environment_firewall_ipset.dns.cidr : dns_server.name]
}

output "global_network_id" {
  description = "Global Network CIDR Alias id"
  value       = proxmox_virtual_environment_firewall_alias.global_network.id
}

output "private_network_id" {
  description = "Private Network CIDR Alias id"
  value       = proxmox_virtual_environment_firewall_alias.private_network.id
}

output "iot_network_id" {
  description = "VPC Network CIDR Alias id"
  value       = proxmox_virtual_environment_firewall_alias.iot_network.id
}

output "vpc_network_id" {
  description = "VPC Network CIDR Alias id"
  value       = proxmox_virtual_environment_firewall_alias.vpc_network.id
}

output "sg_vmdefault" {
  description = "Default SG for all vms's"
  value       = proxmox_virtual_environment_cluster_firewall_security_group.vm_default.name
}

########################
#  CA Certs
########################

output "root_ca_cert" {
  value = tls_self_signed_cert.root.cert_pem
}

output "client_priv_key" {
  value = tls_private_key.client.private_key_pem
  sensitive = true
}

output "client_pub_key" {
  value = tls_private_key.client.public_key_pem
}

output "intranet_cert" {
  value = tls_locally_signed_cert.intranet.cert_pem
}