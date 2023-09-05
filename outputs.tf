##############################################################################
#
# Author: Logan Mancuso
# Created: 07.30.2023
#
##############################################################################

output "available_nodes" {
  description = "List of all Nodes and hostnames in cluster"
  value       = var.nodes
}

output "dc_endpoint" {
  description = "datacenter ip endpoint"
  value       = var.endpoint
}

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

output "preferred_dns" {
  description = "List of configured DNS servers"
  value       = [for dns_server in proxmox_virtual_environment_firewall_ipset.dns.cidr : dns_server.name]
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
