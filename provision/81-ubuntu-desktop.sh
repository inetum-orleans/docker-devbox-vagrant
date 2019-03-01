#!/bin/bash

export DEBIAN_FRONTEND=noninteractive
sudo apt install -y ubuntu-desktop

# Workaround for .local domain not working since ubuntu 18.04
# See https://askubuntu.com/questions/1068131/ubuntu-18-04-local-domain-dns-lookup-not-working
sudo systemctl disable avahi-daemon
sudo service stop avahi-daemon

wget -q -O - https://dl-ssl.google.com/linux/linux_signing_key.pub | sudo apt-key add -
sudo sh -c 'echo "deb http://dl.google.com/linux/chrome/deb/ stable main" >> /etc/apt/sources.list.d/google-chrome.list'
sudo apt-get update
sudo apt-get install -y google-chrome-stable
