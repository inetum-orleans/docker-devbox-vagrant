#!/usr/bin/env bash

./provision/01-prepare.sh
./provision/02-locale.sh
./provision/03-environment-variables.sh
sudo ./provision/04-system-variables.sh
curl -fsSL https://get.docker.com | bash
./provision/31-docker-devbox.sh
./provision/46-node.sh
./provision/47-yeoman.sh
./provision/55-gitconfig.sh
./provision/61-ssh-keys.sh
./provision/99-cleanup.sh

#./provision/options/azure-cli.sh
#./provision/options/git-flow.sh
#./provision/options/php.sh
#./provision/options/python.sh
#./provision/options/vpnc.sh
#./provision/options/vsftpd.sh