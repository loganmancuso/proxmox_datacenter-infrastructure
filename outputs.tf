##############################################################################
#
# Author: Logan Mancuso
# Created: 07.30.2023
#
##############################################################################

output "hostnames" {
  description = "List of all Nodes and hostnames in cluster"
  value       = var.nodes
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

output "preferred_dns" {
  description = "List of configured DNS servers"
  value       = [for dns_server in proxmox_virtual_environment_firewall_ipset.dns.cidr : dns_server.name]
}