#!/usr/bin/env bash
export DEBIAN_FRONTEND=noninteractive

echo "## sources Ubuntu FR"
sudo sed -i 's|http://security.ubuntu.com|http://archive.ubuntu.com|g' /etc/apt/sources.list
sudo sed -i 's|http://archive.ubuntu.com|http://fr.archive.ubuntu.com|g' /etc/apt/sources.list

sudo apt-get clean
sudo apt-get update

echo "## Préparation"
mkdir -p /home/$USER/.provision

sudo usermod -aG sudo vagrant

sudo mkdir -p /usr/share/ca-certificates/private
sudo chmod go+xr /usr/share/ca-certificates/private

if [ -d /home/$USER/persistent_storage ]
then
    sudo chown $USER:$USER /home/$USER/persistent_storage
fi

# Add symlinks from custom ca certificates on the proper location
sudo rm -f /usr/local/share/ca-certificates/*
sudo ln -sf /usr/share/ca-certificates/private/* /usr/local/share/ca-certificates

# sudo systemctl restart systemd-resolved.service
if (dpkg -l avahi-daemon); then
  # avahi-daemon may cause issues with .local domains
  sudo systemctl disable avahi-daemon
  sudo systemctl stop avahi-daemon

  # purge the package to remove it's reference inside /etc/nsswitch.conf (mdns4 / mdns4_minimal)
  sudo apt-get purge -fy avahi-daemon
fi

# Install tools missing from minimal distribution
sudo apt-get install -y curl net-tools

# Use dnsmasq for .test domains and fix .local domains by bypassing systemd-resolved with resolvconf
sudo apt-get install -y dnsmasq resolvconf

# Disable systemd-resolved by adding fallback resolv.conf file to resolvconf tail
sudo ln -fs /run/systemd/resolve/resolv.conf /etc/resolvconf/resolv.conf.d/tail

# inotify limit
echo fs.inotify.max_user_watches=524288 | sudo tee -a /etc/sysctl.conf && sudo sysctl -p && sudo sysctl --system

sudo resolvconf --enable-updates
sudo resolvconf -u
