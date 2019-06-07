#!/usr/bin/env bash
echo "## Environment variables configuration (privileged)"

export SSL_CERT_FILE="/etc/ssl/certs/ca-certificates.crt"
export NODE_EXTRA_CA_CERTS="/etc/ssl/certs/ca-certificates.crt"

if [ -f "$SSL_CERT_FILE" ]; then
  if grep -q "NODE_EXTRA_CA_CERTS=" "/etc/environment"; then
    sudo sed -i "s|.*NODE_EXTRA_CA_CERTS=.*|export NODE_EXTRA_CA_CERTS=${NODE_EXTRA_CA_CERTS}|" "/etc/environment"
  else
    sudo echo "export NODE_EXTRA_CA_CERTS=${NODE_EXTRA_CA_CERTS}">>"/etc/environment"
  fi
  if grep -q "SSL_CERT_FILE=" "/etc/environment";then
    sudo sed -i "s|.*SSL_CERT_FILE=.*|export SSL_CERT_FILE=${SSL_CERT_FILE}|" "/etc/environment"
  else
    sudo echo "export SSL_CERT_FILE=${SSL_CERT_FILE}">>"/etc/environment"
  fi
fi
