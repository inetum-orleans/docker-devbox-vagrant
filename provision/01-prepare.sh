#!/bin/bash

echo "## Préparation"
mkdir -p /home/$USER/.provision

sudo mkdir -p /usr/share/ca-certificates/private
sudo chmod go+xr /usr/share/ca-certificates/private

if [ -d /home/$USER/persistent_storage ]
then
    sudo chown $USER:$USER /home/$USER/persistent_storage
fi

# Add symlinks from custom ca certificates on the proper location
sudo rm -f /usr/local/share/ca-certificates/*
sudo ln -sf /usr/share/ca-certificates/private/* /usr/local/share/ca-certificates
