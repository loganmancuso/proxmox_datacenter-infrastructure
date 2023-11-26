##############################################################################
#
# Author: Logan Mancuso
# Created: 07.30.2023
#
##############################################################################

# RSA KeyPair #
resource "tls_private_key" "root" {
  algorithm = "RSA"
  rsa_bits  = 4096
}

resource "tls_private_key" "client" {
  algorithm = "RSA"
  rsa_bits  = 4096
}

# Certificate Authority #
resource "tls_self_signed_cert" "root" {
  private_key_pem = tls_private_key.root.private_key_pem

  subject {
    common_name  = "loganmancuso.local"
    organization = "loganmancuso"
    country      = "US"
    locality     = "Blythewood"
    postal_code  = "29016"
    province     = "SC"
  }

  validity_period_hours = 3650
  early_renewal_hours   = 365

  allowed_uses = [
    "key_encipherment",
    "cert_signing",
    "digital_signature",
    "server_auth",
  ]
}

# Request Cert from CA #
resource "tls_cert_request" "infranet" {
  private_key_pem = tls_private_key.client.private_key_pem

  subject {
    common_name  = "*.loganmancuso.local"
    organization = "loganmancuso"
    country      = "US"
    locality     = "Blythewood"
    postal_code  = "29016"
    province     = "SC"
  }
}

# Issue Intermediate Cert #
resource "tls_locally_signed_cert" "intranet" {
  cert_request_pem   = tls_cert_request.infranet.cert_request_pem
  ca_private_key_pem = tls_private_key.root.private_key_pem
  ca_cert_pem        = tls_self_signed_cert.root.cert_pem

  validity_period_hours = 365
  early_renewal_hours   = 36

  allowed_uses = [
    "key_encipherment",
    "digital_signature",
    "server_auth",
  ]
}
