#!/bin/bash
export DEBIAN_FRONTEND=noninteractive

echo "## sources Ubuntu FR"
sudo sed -i 's|http://security.ubuntu.com|http://archive.ubuntu.com|g' /etc/apt/sources.list
sudo sed -i 's|http://archive.ubuntu.com|http://fr.archive.ubuntu.com|g' /etc/apt/sources.list

sudo apt-get clean
sudo apt-get update

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
