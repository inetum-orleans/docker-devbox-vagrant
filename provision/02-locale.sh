#!/bin/bash
export DEBIAN_FRONTEND=noninteractive

if [[ ! -z "$CONFIG_LOCALE" ]]; then
  sudo locale-gen "$CONFIG_LOCALE"
  sudo update-locale LANG="$CONFIG_LOCALE" LANGUAGE="$CONFIG_LANGUAGE"

  echo LANGUAGE DEFAULT=$CONFIG_LANGUAGE>/home/vagrant/.pam_environment
  echo LANG DEFAULT=$CONFIG_LOCALE>>/home/vagrant/.pam_environment
  echo LC_NUMERIC DEFAULT=$CONFIG_LOCALE>>/home/vagrant/.pam_environment
  echo LC_TIME DEFAULT=$CONFIG_LOCALE>>/home/vagrant/.pam_environment
  echo LC_MONETARY DEFAULT=$CONFIG_LOCALE>>/home/vagrant/.pam_environment
  echo LC_PAPER DEFAULT=$CONFIG_LOCALE>>/home/vagrant/.pam_environment
  echo LC_NAME DEFAULT=$CONFIG_LOCALE>>/home/vagrant/.pam_environment
  echo LC_ADDRESS DEFAULT=$CONFIG_LOCALE>>/home/vagrant/.pam_environment
  echo LC_TELEPHONE DEFAULT=$CONFIG_LOCALE>>/home/vagrant/.pam_environment
  echo LC_MEASUREMENT DEFAULT=$CONFIG_LOCALE>>/home/vagrant/.pam_environment
  echo LC_IDENTIFICATION DEFAULT=$CONFIG_LOCALE>>/home/vagrant/.pam_environment
fi

if [[ -z "$CONFIG_KEYBOARD_LAYOUT" ]]; then
  sudo setxkbmap us
  sudo sed -i 's/XKBLAYOUT=\".*"/XKBLAYOUT=\"us\"/g' /etc/default/keyboard
else
  sudo setxkbmap "$CONFIG_KEYBOARD_LAYOUT"
  sudo sed -i 's/XKBLAYOUT=\".*"/XKBLAYOUT=\"'"${CONFIG_KEYBOARD_LAYOUT}"'\"/g' /etc/default/keyboard
fi

if [[ -z "$CONFIG_KEYBOARD_VARIANT" ]]; then
  sudo sed -i 's/XKBVARIANT=\".*"/XKBVARIANT=\"\"/g' /etc/default/keyboard
else
  sudo setxkbmap "$CONFIG_KEYBOARD_LAYOUT" "$CONFIG_KEYBOARD_VARIANT"
  sudo sed -i 's/XKBVARIANT=\".*"/XKBVARIANT=\"'"${CONFIG_KEYBOARD_VARIANT}"'\"/g' /etc/default/keyboard
fi

