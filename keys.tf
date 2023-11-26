##############################################################################
#
# Author: Logan Mancuso
# Created: 07.30.2023
#
##############################################################################

# Root Keys #
resource "local_file" "root_priv" {
  content  = tls_private_key.root.private_key_pem
  filename = "${path.module}/keys/root/privkey.pem"
}
resource "local_file" "root_pub" {
  content  = tls_private_key.root.public_key_pem
  filename = "${path.module}/keys/root/pubkey.pem"
}

# Root Certificate Authority #
resource "local_file" "root_ca" {
  content  = tls_self_signed_cert.root.cert_pem
  filename = "${path.module}/keys/root/cert-authority.pem"
}

# Client Keys #
resource "local_file" "client_priv" {
  content  = tls_private_key.client.private_key_pem
  filename = "${path.module}/keys/client/privkey.pem"
}
resource "local_file" "client_pub" {
  content  = tls_private_key.client.public_key_pem
  filename = "${path.module}/keys/client/pubkey.pem"
}

# Intermediate Intranet Cert #
resource "local_file" "intranet_cert" {
  content  = tls_locally_signed_cert.intranet.cert_pem
  filename = "${path.module}/keys/client/cert-intranet.pem"
}
