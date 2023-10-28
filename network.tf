##############################################################################
#
# Author: Logan Mancuso
# Created: 07.30.2023
#
##############################################################################

resource "proxmox_virtual_environment_dns" "dns_config" {
  for_each  = var.nodes
  node_name = each.key
  # yours may vary
  domain = "local"

  servers = [for srv in var.dns_servers : srv]
}

resource "proxmox_virtual_environment_hosts" "hosts" {
  for_each  = var.nodes
  node_name = each.key
  entry {
    address = "127.0.0.1"

    hostnames = [
      "localhost",
      "localhost.localdomain"
    ]
  }
  entry {
    address = each.value

    hostnames = [
      "${each.key}.local",
      "${each.key}"
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

# terraform import proxmox_virtual_environment_network_linux_bridge.vmbr0[\"pve-master\"] pve:vmbr0
resource "proxmox_virtual_environment_network_linux_bridge" "vmbr0" {
  for_each   = var.nodes
  node_name  = each.key
  name       = "vmbr0"
  autostart  = true
  vlan_aware = true
  address    = "${each.value}/24"
  gateway    = var.dns_servers["local"]
  comment    = "default bridge interface"
  ports = [
    local.workspace == "sandbox" ? "eth0" : local.workspace == "prod" ? "enp37s0" : "None"
  ]
}
