#!/bin/bash
export DEBIAN_FRONTEND=noninteractive

echo "## Installing desktop environement"
sudo apt-get install -fy kubuntu-desktop

kwriteconfig5 --file ~/.config/kscreenlockerrc --group Daemon --key Autolock --type bool false
kwriteconfig5 --file ~/.config/kscreenlockerrc --group Daemon --key LockOnResume --type bool false
sudo kwriteconfig5 --file /etc/sddm.conf --group Autologin --key User --type string vagrant

sudo apt-get -y install `check-language-support -l $CONFIG_LANGUAGE`

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
