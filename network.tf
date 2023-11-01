##############################################################################
#
# Author: Logan Mancuso
# Created: 07.30.2023
#
##############################################################################

resource "proxmox_virtual_environment_dns" "dns_config" {
  node_name = var.node_name
  domain    = "local"
  servers   = [for srv in var.dns_servers : srv]
}

resource "proxmox_virtual_environment_hosts" "hosts" {
  node_name = var.node_name
  entry {
    address = "127.0.0.1"

    hostnames = [
      "localhost",
      "localhost.localdomain"
    ]
  }
  entry {
    address = var.node_ip

    hostnames = [
      "${var.node_name}.local",
      "${var.node_name}"
    ]
  }
  # The following lines are desirable for IPv6 capable hosts
  entry {
    address = "::1"

    hostnames = [
      "ip6-localhost",
      "ip6-loopback"
    ]
  }
  entry {
    address = "fe00::0"

    hostnames = [
      "ip6-localnet"
    ]
  }
  entry {
    address = "ff00::0"

    hostnames = [
      "ip6-mcastprefix"
    ]
  }
  entry {
    address = "ff02::1"

    hostnames = [
      "ip6-allnodes"
    ]
  }
  entry {
    address = "ff02::2"

    hostnames = [
      "ip6-allrouters"
    ]
  }
  entry {
    address = "ff02::3"

    hostnames = [
      "ip6-allhosts"
    ]
  }
}

# terraform import proxmox_virtual_environment_network_linux_bridge.vmbr0[\"node_name\"] node_name:vmbr0
resource "proxmox_virtual_environment_network_linux_bridge" "vmbr0" {
  node_name  = var.node_name
  name       = "vmbr0"
  autostart  = true
  vlan_aware = true
  address    = "${var.node_ip}/24"
  gateway    = var.dns_servers["local"]
  comment    = "default bridge interface"
  ports      = var.node_onboard_nics
  lifecycle {
    # if you destroy this resource it could break proxmox
    prevent_destroy = true
  }
}
