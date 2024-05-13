#!/usr/bin/env bash
echo "## Environment variables configuration"

add_variable_to_profile () {
  var="$1"
  val="$2"
  label="$3"

  echo "$var: $val ($label)"

  if grep -q "$var=" "${HOME}/.profile"; then
    sed -i "s|.*$var=.*|export $var=$val|" "${HOME}/.profile"
  else
    echo -e>>"${HOME}/.profile"
    echo "# $label">>"${HOME}/.profile"
    echo "export $var=\"$val\"">>"${HOME}/.profile"
  fi
}

HOST_IP="${HOST_IP:=127.0.0.1}"
add_variable_to_profile "HOST_IP" "$HOST_IP" "Host IP Address"
export HOST_IP=${HOST_IP}

LOCAL_IP="${LOCAL_IP:=127.0.0.1}"
add_variable_to_profile "LOCAL_IP" "$LOCAL_IP" "Local IP Address"
export LOCAL_IP=${LOCAL_IP}
