#!/usr/bin/env bash

mkdir -p /home/$USER/.cache/yarn

curl -sL https://deb.nodesource.com/setup_10.x | sed 's|https://|http://|' | sudo -E bash -
export DEBIAN_FRONTEND=noninteractive
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

curl -sL https://raw.githubusercontent.com/glenpike/npm-g_nosudo/master/npm-g-nosudo.sh | sh

cat $HOME/.bashrc | grep "# npm-g-nosudo Configuration"
NPM_G_NOSUDO_CONFIGURED=$?
if [ "$NPM_G_NOSUDO_CONFIGURED" != "0" ]; then
    echo -e>>$HOME/.bashrc
    echo "# npm-g-nosudo Configuration">>$HOME/.bashrc
    echo -e>>$HOME/.bashrc
    echo "export NPM_PACKAGES=\"/home/vagrant/.npm-packages\"">>$HOME/.bashrc
    echo "export NODE_PATH=\"\$NPM_PACKAGES/lib/node_modules\${NODE_PATH:+:\$NODE_PATH}\"">>$HOME/.bashrc
    echo "export PATH=\"\$NPM_PACKAGES/bin:\$PATH\"">>$HOME/.bashrc
    echo "unset MANPATH  # delete if you already modified MANPATH elsewhere in your config">>$HOME/.bashrc
    echo "export MANPATH=\"\$NPM_PACKAGES/share/man:$(manpath)\"">>$HOME/.bashrc
fi
