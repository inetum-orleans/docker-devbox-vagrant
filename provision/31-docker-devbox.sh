#!/usr/bin/env bash

sudo apt-get update && sudo apt-get install -y make jq

CFSSL_CLI_VERSION=$(curl -s https://api.github.com/repos/Toilal/python-cfssl-cli/releases/latest | grep 'tag_name' | cut -d\" -f4)
echo "## Installation de cfssl-cli $CFSSL_CLI_VERSION"

curl -sL -o ./cfssl-cli https://github.com/Toilal/python-cfssl-cli/releases/download/$CFSSL_CLI_VERSION/cfssl-cli
sudo mv ./cfssl-cli /usr/local/bin/cfssl-cli

sudo chmod +x /usr/local/bin/cfssl-cli

MKCERT_VERSION=$(curl -s https://api.github.com/repos/FiloSottile/mkcert/releases/latest | grep 'tag_name' | cut -d\" -f4)
echo "## Installation de mkcert $MKCERT_VERSION"

curl -fsSL -o ./mkcert "https://github.com/FiloSottile/mkcert/releases/download/$MKCERT_VERSION/mkcert-$MKCERT_VERSION-linux-amd64"
sudo mv ./mkcert /usr/local/bin/mkcert

sudo chmod +x /usr/local/bin/mkcert

echo "## Installation de docker-devbox"
curl -L https://github.com/gfi-centre-ouest/docker-devbox/raw/master/installer | bash

mkdir -p "$HOME/projects"
