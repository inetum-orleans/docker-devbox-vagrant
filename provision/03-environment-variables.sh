#!/bin/bash

# Ce script doit être lancé avec l'utilisateur vagrant (Utiliser privileged: false dans Vagrantfile)

echo "## Environment variables configuration"

echo "HOST_IP: ${HOST_IP} (Host IP Address)"

if grep -q "HOST_IP=" "${HOME}/.profile"; then
  sed -i "s|.*HOST_IP=.*|export HOST_IP=${HOST_IP}|" "${HOME}/.profile"
else
  echo -e>>"${HOME}/.profile"
  echo "# Host IP Address">>"${HOME}/.profile"
  echo "export HOST_IP=${HOST_IP}">>"${HOME}/.profile"
fi

export HOST_IP=${HOST_IP}

NODE_EXTRA_CA_CERTS=${SSL_CERT_FILE:-/etc/ssl/certs/ca-certificates.crt}

if [ -f "$NODE_EXTRA_CA_CERTS" ]; then
    if grep -q "NODE_EXTRA_CA_CERTS=" "${HOME}/.profile"; then
      sed -i "s|.*NODE_EXTRA_CA_CERTS=.*|export NODE_EXTRA_CA_CERTS=${NODE_EXTRA_CA_CERTS}|" "${HOME}/.profile"
    else
      echo -e>>"${HOME}/.profile"
      echo "# Root certificates bundle for NodeJS">>"${HOME}/.profile"
      echo "export NODE_EXTRA_CA_CERTS=${NODE_EXTRA_CA_CERTS}">>"${HOME}/.profile"
    fi

    export NODE_EXTRA_CA_CERTS=${NODE_EXTRA_CA_CERTS}
else
    echo "No root ca certificates found ($NODE_EXTRA_CA_CERTS)"
fi
