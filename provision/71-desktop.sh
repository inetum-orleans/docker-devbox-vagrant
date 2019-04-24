#!/bin/bash
export DEBIAN_FRONTEND=noninteractive

echo "## Installing desktop environement"
sudo apt-get install -fy kubuntu-desktop

if (dpkg -l avahi-daemon); then
  # avahi-daemon may cause issues with .local domains
  sudo systemctl disable avahi-daemon
  sudo systemctl stop avahi-daemon

  # purge the package to remove it's reference inside /etc/nsswitch.conf (mdns4 / mdns4_minimal)
  sudo apt-get purge -fy avahi-daemon
fi

sudo DEBIAN_FRONTEND=noninteractive apt-get install -qy virtualbox-guest-dkms virtualbox-guest-x11
#sudo apt-get purge -fy avahi-daemon
#sudo apt-get install -fy resolvconf
