##############################################################################
#
# Author: Logan Mancuso
# Created: 07.30.2023
#
##############################################################################

node_name         = "pve-test"
node_ip           = "192.168.122.26"
node_onboard_nics = ["enp1s0"]

dns_servers = {
  "1and1"     = "1.1.1.1",
  "1and1_alt" = "1.0.0.1",
  "local"     = "192.168.122.1"
}