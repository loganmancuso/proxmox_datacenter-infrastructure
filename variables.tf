##############################################################################
#
# Author: Logan Mancuso
# Created: 07.30.2023
#
##############################################################################

#######################################
# Node Variables
#######################################

variable "node_name" {
  type = string
}

variable "node_ip" {
  type = string
}

variable "node_onboard_nics" {
  type = list(string)
}

variable "root_password" {
  type      = string
  sensitive = true
}

variable "dns_servers" {
  type = map(string)
}