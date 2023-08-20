##############################################################################
#
# Author: Logan Mancuso
# Created: 07.30.2023
#
##############################################################################

#######################################
# Global Variables
#######################################

variable "endpoint" {
  type = string
}

variable "root_password" {
  type      = string
  sensitive = true
}

variable "instance_password" {
  type = string
  sensitive = true
}

variable "nodes" {
  type = map(string)
}

variable "dns_servers" {
  type = map(string)
}

variable "ops_password" {
  type      = string
  sensitive = true
}