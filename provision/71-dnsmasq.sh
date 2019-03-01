#!/bin/bash

# Resolve *.test domains to 127.0.0.1

sudo apt-get install -y dnsmasq
sudo sh -c "echo address=/.test/127.0.0.1>/etc/dnsmasq.d/test-domain-to-localhost"

sudo sh -c "echo nameserver 127.0.0.1>/etc/resolv.conf"
