#!/usr/bin/env bash

echo "## Nettoyage"
export DEBIAN_FRONTEND=noninteractive
sudo apt-get -fy autoremove
