#!/usr/bin/env bash

echo "## Installation de vpnc"
export DEBIAN_FRONTEND=noninteractive
sudo apt-get -fy install vpnc

sudo chmod go+r /etc/vpnc
