#!/bin/bash

echo "## Paramétrage du proxy pour Docker"
mkdir -p /etc/systemd/system/docker.service.d

rm -f /etc/systemd/system/docker.service.d/http-proxy.conf

if [ -n "$http_proxy" ]; then echo "http_proxy=$http_proxy"; fi
if [ -n "$https_proxy" ]; then echo "https_proxy=$https_proxy"; fi
if [ -n "$no_proxy" ]; then echo "no_proxy=$no_proxy"; fi

if [ -z "$http_proxy$https_proxy" ]; then echo "No proxy is defined."; fi
if [ -n "$http_proxy$https_proxy" ]; then

touch /etc/systemd/system/docker.service.d/http-proxy.conf
chown ubuntu:ubuntu /etc/systemd/system/docker.service.d/http-proxy.conf
echo '[Service]' > /etc/systemd/system/docker.service.d/http-proxy.conf
echo "Environment=\"HTTP_PROXY=$http_proxy\" \"HTTPS_PROXY=$https_proxy\" \"NO_PROXY=$no_proxy\"" >> /etc/systemd/system/docker.service.d/http-proxy.conf

fi;