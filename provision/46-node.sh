#!/usr/bin/env bash

mkdir -p /home/ubuntu/.cache/yarn

curl -sL https://deb.nodesource.com/setup_8.x | sudo -E bash -
sudo apt-get update && sudo apt-get install -y nodejs

# sudo apt-get install -y build-essential

curl -sS https://dl.yarnpkg.com/debian/pubkey.gpg | sudo apt-key add -
echo "deb https://dl.yarnpkg.com/debian/ stable main" | sudo tee /etc/apt/sources.list.d/yarn.list
sudo apt-get update && sudo apt-get install yarn
