#!/bin/bash
export DEBIAN_FRONTEND=noninteractive

echo "## Installing desktop environement"
sudo apt-get install kde-plasma-desktop
sudo apt-get purge -fy avahi-daemon
sudo apt-get install resolvconf

echo "## Installing Git Flow"
sudo apt-get -fy install git-flow

echo "## Installing Brave browser"
curl -s https://brave-browser-apt-release.s3.brave.com/brave-core.asc | sudo apt-key --keyring /etc/apt/trusted.gpg.d/brave-browser-release.gpg add -
source /etc/os-release
echo "deb [arch=amd64] https://brave-browser-apt-release.s3.brave.com/ $UBUNTU_CODENAME main" | sudo tee /etc/apt/sources.list.d/brave-browser-release-${UBUNTU_CODENAME}.list
sudo apt update
sudo apt install brave-keyring brave-browser
