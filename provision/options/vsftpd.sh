#!/usr/bin/env bash

echo "## Installation de vsftpd"
export DEBIAN_FRONTEND=noninteractive
sudo apt-get -fy install vsftpd

sudo cp /etc/vsftpd.conf /etc/vsftpd.conf.orig

sudo sed -i 's/dirmessage_enable=YES/dirmessage_enable=NO/g' /etc/vsftpd.conf
sudo sed -i 's/#write_enable=YES/write_enable=YES/g' /etc/vsftpd.conf

if ! grep -qF 'force_dot_files=' /etc/vsftpd.conf; then
  echo 'force_dot_files=YES' | sudo tee -a /etc/vsftpd.conf> /dev/null
fi

sudo service vsftpd restart

