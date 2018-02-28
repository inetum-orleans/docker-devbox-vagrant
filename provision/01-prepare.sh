#!/bin/bash

echo "## Préparation"
mkdir -p /home/$USER/.provision

sudo mkdir -p /usr/share/ca-certificates/private
sudo chmod go+xr /usr/share/ca-certificates/private

