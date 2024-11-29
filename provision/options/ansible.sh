#!/usr/bin/env bash

echo "## Installing Ansible"
sudo apt-add-repository ppa:ansible/ansible
sudo apt update
sudo apt install ansible -y