#!/bin/bash
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

LOCAL_IP="${LOCAL_IP:=127.0.0.1}"
echo "LOCAL_IP: ${LOCAL_IP} (Local IP Address)"

if grep -q "LOCAL_IP=" "${HOME}/.profile"; then
  sed -i "s|.*LOCAL_IP=.*|export LOCAL_IP=${LOCAL_IP}|" "${HOME}/.profile"
else
  echo -e>>"${HOME}/.profile"
  echo "# Local IP Address">>"${HOME}/.profile"
  echo "export LOCAL_IP=${LOCAL_IP}">>"${HOME}/.profile"
fi

export LOCAL_IP=${LOCAL_IP}
