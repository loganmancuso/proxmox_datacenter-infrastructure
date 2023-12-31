##############################################################################
#
# Author: Logan Mancuso
# Created: 11.27.2023
#
##############################################################################

resource "proxmox_virtual_environment_time" "node_time" {
  node_name = var.node_name
  time_zone = "America/New_York"
}

#######################################
# Cluster Alias
#######################################
resource "proxmox_virtual_environment_firewall_alias" "cluster_alias" {
  name    = var.node_name
  cidr    = "${var.node_ip}/24"
  comment = "alias"
}

#######################################
# Cert Management
#######################################
# Request Cert from CA #
resource "tls_cert_request" "node_cert_request" {
  private_key_pem = local.client_priv_key
  dns_names = [
    "127.0.0.1",
    "localhost",
    "${var.node_ip}",
    "${var.node_name}.local",
    "${var.node_name}.loganmancuso.duckdns.org",
  ]
  subject {
    common_name  = "${var.node_name}.local"
    organization = "loganmancuso"
    country      = "US"
    locality     = "Blythewood"
    postal_code  = "29016"
    province     = "SC"
  }
}

# Issue Intermediate Cert #
resource "tls_locally_signed_cert" "node" {
  cert_request_pem   = tls_cert_request.node_cert_request.cert_request_pem
  ca_private_key_pem = local.root_priv_key
  ca_cert_pem        = local.cert_root

  validity_period_hours = 365
  early_renewal_hours   = 36

  allowed_uses = [
    "key_encipherment",
    "digital_signature",
    "server_auth",
    "any_extended"
  ]
}
resource "proxmox_virtual_environment_certificate" "node_cert" {
  node_name   = var.node_name
  certificate = tls_locally_signed_cert.node.cert_pem
  private_key = local.client_priv_key
}

#######################################
# Bootstrap Node
#######################################

locals {
  helper_src    = "${path.module}/scripts/tofu"
  helper_dst    = "/opt/tofu"
  bootstrap_src = "${path.module}/scripts/bootstrap.sh"
  bootstrap_dst = "/opt/tofu/bootstrap.sh"
  bootstrap_cmd = "ssh -t root@${var.node_ip} 'chmod u+x,g+x ${local.bootstrap_dst} && ${local.bootstrap_dst}'"
}

resource "terraform_data" "bootstrap_node" {
  triggers_replace = [md5(file(local.bootstrap_src))]
  provisioner "file" {
    when        = create
    source      = local.helper_src
    destination = local.helper_dst
    connection {
      type        = "ssh"
      user        = "root" # proxmox nodes only work through the root user right now
      private_key = file("~/.ssh/id_ed25519")
      host        = var.node_ip
    }
  }
  provisioner "file" {
    when = create
    content = templatefile(local.bootstrap_src,
      {
        log_dst = "/var/log/tofu/bootstrap.log"
      }
    )
    destination = local.bootstrap_dst
    connection {
      type        = "ssh"
      user        = "root" # proxmox nodes only work through the root user right now
      private_key = file("~/.ssh/id_ed25519")
      host        = var.node_ip
    }
  }
  provisioner "local-exec" {
    command = local.bootstrap_cmd
  }
}
