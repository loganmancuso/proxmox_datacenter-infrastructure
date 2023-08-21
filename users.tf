##############################################################################
#
# Author: Logan Mancuso
# Created: 07.30.2023
#
##############################################################################

#######################################
# Users and Groups
#######################################
resource "proxmox_virtual_environment_group" "operations_team" {
  comment  = "Terraform Deployment Ops Team"
  group_id = "operations-team"
}

resource "proxmox_virtual_environment_role" "operations_team" {
  role_id = "operations-role"
  # Admin of the system
  privileges = data.proxmox_virtual_environment_roles.available_roles.privileges[0]
}

resource "proxmox_virtual_environment_user" "operations_automation" {
  acl {
    path      = "/"
    propagate = true
    role_id   = proxmox_virtual_environment_role.operations_team.role_id
  }
  groups   = [proxmox_virtual_environment_group.operations_team.group_id]
  comment  = "Terraform Deployment User"
  password = var.ops_password
  user_id  = "operations@pve"
}