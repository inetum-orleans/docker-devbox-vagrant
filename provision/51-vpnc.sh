#!/usr/bin/env bash

echo "## Installation de vpnc"
export DEBIAN_FRONTEND=noninteractive
apt-get -fy install vpnc

chmod go+r /etc/vpnc
