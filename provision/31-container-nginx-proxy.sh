#!/bin/bash
if [ ! "$(docker ps -a | grep nginx-proxy)" ]; then
    echo "## Installation du container nginx-proxy"
    docker network create nginx-proxy || true
    docker run -d -p 80:80 --restart unless-stopped --net nginx-proxy -v /var/run/docker.sock:/tmp/docker.sock:ro --name nginx-proxy jwilder/nginx-proxy
else
    echo "## Le container nginx-proxy est déjà installé"
fi
