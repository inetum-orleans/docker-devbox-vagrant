#!/bin/bash
echo "## Configuration du proxy système"

if [ -n "$http_proxy" ]; then echo "http_proxy=$http_proxy"; fi
if [ -n "$https_proxy" ]; then echo "https_proxy=$https_proxy"; fi
if [ -n "$no_proxy" ]; then echo "no_proxy=$no_proxy"; fi

if [ -z "$http_proxy$https_proxy" ]; then echo "No proxy is defined."; fi

echo "PATH=$PATH">/etc/environment
if [ -n "$http_proxy" ]; then echo "http_proxy=$http_proxy">> /etc/environment; fi
if [ -n "$https_proxy" ]; then echo "https_proxy=$https_proxy">> /etc/environment; fi
if [ -n "$no_proxy" ]; then echo "no_proxy=$no_proxy">> /etc/environment; fi
if [ -n "$http_proxy" ]; then echo "HTTP_PROXY=$http_proxy">> /etc/environment; fi
if [ -n "$https_proxy" ]; then echo "HTTPS_PROXY=$https_proxy">> /etc/environment; fi
if [ -n "$no_proxy" ]; then echo "NO_PROXY=$no_proxy">> /etc/environment; fi
