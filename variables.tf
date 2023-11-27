##############################################################################
#
# Author: Logan Mancuso
# Created: 11.27.2023
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

variable "dns_servers" {
  type = map(string)
}