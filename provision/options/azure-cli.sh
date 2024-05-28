#!/usr/bin/env bash

sudo apt-get update && sudo apt-get install -y curl apt-transport-https lsb-release gnupg

curl -sL https://packages.microsoft.com/keys/microsoft.asc | gpg --dearmor | sudo tee /etc/apt/trusted.gpg.d/microsoft.asc.gpg > /dev/null

echo "deb [arch=amd64] https://packages.microsoft.com/repos/azure-cli/ $(lsb_release -cs) main" | sudo tee /etc/apt/sources.list.d/azure-cli.list

sudo apt-get update && sudo apt-get install azure-cli

# If the azure username is set
if [ -n "$AZ_USERNAME" ]; then
  az login --service-principal --username $AZ_USERNAME -p "$AZ_PASSWORD" --tenant $AZ_TENANT
  # Test if user crontab contains `az acr login --name gfiorleans`. If not, add it.
  if ! crontab -l | grep -q "az acr login --name gfiorleans"; then
    (crontab -l 2>/dev/null; echo "0,15,30,45 * * * * az acr login --name gfiorleans") | crontab -
  fi
fi
