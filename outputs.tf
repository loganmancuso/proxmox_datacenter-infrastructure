##############################################################################
#
# Author: Logan Mancuso
# Created: 07.30.2023
#
##############################################################################

########################
#  DC Variables
########################
output "available_nodes" {
  description = "List of all Nodes and hostnames in cluster"
  value       = var.nodes
}

output "dc_endpoint" {
  description = "datacenter ip endpoint"
  value       = var.endpoint
}

########################
#  User Variables
########################
output "root_password" {
  description = "node root password"
  sensitive   = true
  value       = var.root_password
}

output "operations_role" {
  description = "operations role"
  value       = proxmox_virtual_environment_role.operations_team.role_id
}

output "operations_user" {
  description = "operations user"
  value       = proxmox_virtual_environment_user.operations_automation.user_id
}

output "operations_user_password" {
  description = "operations user"
  sensitive   = true
  value       = proxmox_virtual_environment_user.operations_automation.password
}

output "instance_credentials" {
  description = "VM instance credentials"
  sensitive   = true
  value = {
    username = "instance-user"
    password = var.instance_password
    key      = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAINQj0vO0eNNKtED9at+T1h2Xj3K4sMHlyPoHx+ON+WLS mickeyacejr@live.com"
  }
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

output "vpc_network_id" {
  description = "VPC Network CIDR Alias id"
  value       = proxmox_virtual_environment_firewall_alias.vpc.id
}