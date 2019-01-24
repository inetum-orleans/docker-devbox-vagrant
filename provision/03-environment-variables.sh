#!/bin/bash

# Ce script doit être lancé avec l'utilisateur vagrant (Utiliser privileged: false dans Vagrantfile)

echo "## Environment variables configuration"

HOST_IP="${HOST_IP:=127.0.0.1}"
echo "HOST_IP: ${HOST_IP} (Host IP Address)"

if grep -q "HOST_IP=" "${HOME}/.profile"; then
  sed -i "s|.*HOST_IP=.*|export HOST_IP=${HOST_IP}|" "${HOME}/.profile"
else
  echo -e>>"${HOME}/.profile"
  echo "# Host IP Address">>"${HOME}/.profile"
  echo "export HOST_IP=${HOST_IP}">>"${HOME}/.profile"
fi

export HOST_IP=${HOST_IP}
export SSL_CERT_FILE="/etc/ssl/certs/ca-certificates.crt"
export NODE_EXTRA_CA_CERTS="/etc/ssl/certs/ca-certificates.crt"

if [ -f "$SSL_CERT_FILE" ]; then
    if ! grep -q "# Root certificates" "${HOME}/.profile"; then
      echo -e>>"${HOME}/.profile"
      echo "# Root certificates">>"${HOME}/.profile"
    fi
    if grep -q "NODE_EXTRA_CA_CERTS=" "${HOME}/.profile"; then
      sed -i "s|.*NODE_EXTRA_CA_CERTS=.*|export NODE_EXTRA_CA_CERTS=${NODE_EXTRA_CA_CERTS}|" "${HOME}/.profile"
    else
      echo "export NODE_EXTRA_CA_CERTS=${NODE_EXTRA_CA_CERTS}">>"${HOME}/.profile"
    fi
    if grep -q "SSL_CERT_FILE=" "${HOME}/.profile";then
      sed -i "s|.*SSL_CERT_FILE=.*|export SSL_CERT_FILE=${SSL_CERT_FILE}|" "${HOME}/.profile"
    else
      echo "export SSL_CERT_FILE=${SSL_CERT_FILE}">>"${HOME}/.profile"
    fi
fi
