#!/bin/bash

echo "## Préparation"
mkdir -p /home/$USER/.provision

sudo mkdir -p /usr/share/ca-certificates/private
sudo chmod go+xr /usr/share/ca-certificates/private

if [ -d /home/$USER/persistent_storage ]
then 
    sudo chown -R $USER:$USER /home/$USER/persistent_storage
fi

