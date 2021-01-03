#!/usr/bin/env bash
echo "## Environment variables configuration"

_add_env_variable() {
  local VARIABLE_NAME="$1"
  local VARIABLE_VALUE="$2"
  local VARIABLE_EXPLANATION="$3"

  echo "${VARIABLE_NAME}: ${VARIABLE_VALUE} (${VARIABLE_EXPLANATION})"
  if grep -q "${VARIABLE_NAME}=" "${HOME}/.profile"; then
    sed -i "s|.*${VARIABLE_NAME}=.*|export ${VARIABLE_NAME}=${VARIABLE_VALUE}|" "${HOME}/.profile"
  else
    echo -e>>"${HOME}/.profile"
    echo "# ${VARIABLE_EXPLANATION}">>"${HOME}/.profile"
    echo "export ${VARIABLE_NAME}=${VARIABLE_VALUE}">>"${HOME}/.profile"
  fi
}

_add_env_variable "HOST_IP" "${HOST_IP:=127.0.0.1}" "Host IP Address"
export HOST_IP=${HOST_IP}

_add_env_variable "LOCAL_IP" "${LOCAL_IP:=127.0.0.1}" "Local IP Address"
export LOCAL_IP=${LOCAL_IP}

_add_env_variable "DNS_SERVERS" "${DNS_SERVERS:=8.8.8.8}" "Fallback DNS Servers"
export DNS_SERVERS=${DNS_SERVERS}
