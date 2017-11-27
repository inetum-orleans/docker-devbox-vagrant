#!/usr/bin/env bash

mkdir -p /home/ubuntu/.cache/yarn

curl -sL https://deb.nodesource.com/setup_8.x | sudo -E bash -
sudo apt-get update && sudo apt-get install -y nodejs

# sudo apt-get install -y build-essential

curl -sS https://dl.yarnpkg.com/debian/pubkey.gpg | sudo apt-key add -
echo "deb https://dl.yarnpkg.com/debian/ stable main" | sudo tee /etc/apt/sources.list.d/yarn.list
sudo apt-get update && sudo apt-get install yarn

cat $HOME/.bashrc | grep "# Yarn Configuration"
YARN_CONFIGURED=$?
if [ "$YARN_CONFIGURED" != "0" ]; then
    echo -e>>$HOME/.bashrc
    echo "# Yarn Configuration">>$HOME/.bashrc
    echo PATH="$PATH:$(yarn global bin)">>$HOME/.bashrc
    echo "Enregistrement de yarn (~/.bashrc)"
fi
